<script setup>
import { computed, onMounted, ref } from 'vue'
import KartyatarsasagJelzo from './components/KartyatarsasagJelzo.vue'
import KartyaszamBevitel from './components/KartyaszamBevitel.vue'
import EredmenyDoboz from './components/EredmenyDoboz.vue'
import ElozmenyekTablazat from './components/ElozmenyekTablazat.vue'
import StatisztikaPanel from './components/StatisztikaPanel.vue'
import { szerver } from './segedek/szerver.js'
import {
  kartyatarsasagMeghataroz,
  luhnEllenoriz,
  veletlenKartyaszam,
  hibasKartyaszam
} from './segedek/luhnSeged.js'

const szamjegyek = ref(Array(16).fill(''))
const eredmeny = ref(null)
const hibauzenet = ref('')
const toltesAlatt = ref(false)
const elozmenyek = ref([])
const statisztika = ref(null)
const bevitel = ref(null)

const kartyaszam = computed(() => szamjegyek.value.join(''))
const teljes = computed(() => szamjegyek.value.every((jegy) => jegy !== ''))
const elotag = computed(() => {
  const elsoUres = szamjegyek.value.indexOf('')
  return (elsoUres === -1 ? szamjegyek.value : szamjegyek.value.slice(0, elsoUres)).join('')
})
const kartyatarsasag = computed(() => kartyatarsasagMeghataroz(elotag.value))
const elozetesEredmeny = computed(() => {
  if (!teljes.value) return 'nincs'
  return luhnEllenoriz(kartyaszam.value) ? 'helyes' : 'hibas'
})

function mezokFeltoltese(szoveg) {
  szamjegyek.value = Array.from({ length: 16 }, (_, i) => szoveg[i] ?? '')
  eredmeny.value = null
  hibauzenet.value = ''
}

function szamjegyFrissites({ index, ertek }) {
  szamjegyek.value[index] = ertek
  eredmeny.value = null
  hibauzenet.value = ''
}

function szamjegyekBeillesztese(szamokSzoveg) {
  mezokFeltoltese(szamokSzoveg)
}

function veletlenKartyaGeneralas() {
  mezokFeltoltese(veletlenKartyaszam())
}

function hibasKartyaGeneralas() {
  mezokFeltoltese(hibasKartyaszam())
}

function mezokTorlese() {
  mezokFeltoltese('')
  bevitel.value?.fokuszElso()
}

function hibaSzovege(hiba) {
  const valasz = hiba.response
  if (!valasz) return 'Nem érkezett válasz a szervertől (nem fut, rossz a cím, vagy CORS-tiltás). Nézze meg a konzolt.'
  if (valasz.status === 502) return 'A szerver nem érhető el. Fut a php artisan serve?'
  if (valasz.status === 422) return valasz.data.errors?.kartyaszam?.[0] ?? valasz.data.message
  if (valasz.data?.error) return valasz.data.error
  return `Váratlan hiba történt (${valasz.status}).`
}

async function kartyaEllenorzes() {
  if (!teljes.value) {
    hibauzenet.value = 'Adja meg mind a 16 számjegyet.'
    return
  }
  toltesAlatt.value = true
  hibauzenet.value = ''
  try {
    const valasz = await szerver.post('/ellenorzes', { kartyaszam: kartyaszam.value })
    eredmeny.value = valasz.data
    await Promise.all([elozmenyekLekeres(), statisztikaLekeres()])
  } catch (hiba) {
    eredmeny.value = null
    hibauzenet.value = hibaSzovege(hiba)
  } finally {
    toltesAlatt.value = false
  }
}

async function elozmenyekLekeres() {
  try {
    const valasz = await szerver.get('/elozmenyek')
    elozmenyek.value = valasz.data
  } catch (hiba) {
    hibauzenet.value = hibaSzovege(hiba)
  }
}

async function statisztikaLekeres() {
  try {
    const valasz = await szerver.get('/statisztika')
    statisztika.value = valasz.data
  } catch (hiba) {
    hibauzenet.value = hibaSzovege(hiba)
  }
}

onMounted(() => {
  elozmenyekLekeres()
  statisztikaLekeres()
})
</script>

<template>
  <main class="oldal">
    <h1>Bankkártyaszám ellenőrzése</h1>
    <p>Adja meg a 16 jegyű kártyaszámot</p>
    <KartyatarsasagJelzo :kartyatarsasag="kartyatarsasag" />
    <KartyaszamBevitel
      ref="bevitel"
      :szamjegyek="szamjegyek"
      :elozetes-eredmeny="elozetesEredmeny"
      @szamjegy-modositva="szamjegyFrissites"
      @szamjegyek-beillesztve="szamjegyekBeillesztese"
    />
    <div class="gombok">
      <button type="button" :disabled="toltesAlatt" @click="kartyaEllenorzes">
        {{ toltesAlatt ? 'Ellenőrzés folyamatban…' : 'Ellenőrzés' }}
      </button>
      <button type="button" @click="veletlenKartyaGeneralas">Véletlen szám</button>
      <button type="button" @click="hibasKartyaGeneralas">Hibás szám</button>
      <button type="button" @click="mezokTorlese">Mezők törlése</button>
    </div>
    <p v-if="hibauzenet" class="hiba" role="alert">{{ hibauzenet }}</p>
    <EredmenyDoboz :eredmeny="eredmeny" />
    <ElozmenyekTablazat :elozmenyek="elozmenyek" />
    <StatisztikaPanel :statisztika="statisztika" />
  </main>
</template>
