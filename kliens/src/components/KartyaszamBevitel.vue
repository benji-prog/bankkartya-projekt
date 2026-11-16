<script setup>
import { computed, ref } from 'vue'

const props = defineProps({
  szamjegyek: { type: Array, required: true },
  elozetesEredmeny: {
    type: String,
    default: 'nincs',
    validator: (ertek) => ['nincs', 'helyes', 'hibas'].includes(ertek)
  }
})
const emit = defineEmits(['szamjegy-modositva', 'szamjegyek-beillesztve'])
const csoportok = [0, 1, 2, 3].map((c) => [0, 1, 2, 3].map((e) => c * 4 + e))

const mezoRefek = ref([])

function bevitelKezeles(index, esemeny) {
  const tisztaSzamjegy = esemeny.target.value.replace(/\D/g, '').slice(-1)
  esemeny.target.value = tisztaSzamjegy
  emit('szamjegy-modositva', { index, ertek: tisztaSzamjegy })
  if (tisztaSzamjegy !== '' && index < 15) mezoRefek.value[index + 1]?.focus()
}

function billentyuKezeles(index, esemeny) {
  if (esemeny.key === 'Backspace' && esemeny.target.value === '' && index > 0) {
    mezoRefek.value[index - 1]?.focus()
  }
}

function beillesztesKezeles(esemeny) {
  esemeny.preventDefault()
  const csakSzamok = esemeny.clipboardData.getData('text').replace(/\D/g, '').slice(0, 16)
  emit('szamjegyek-beillesztve', csakSzamok)
  mezoRefek.value[Math.min(csakSzamok.length, 15)]?.focus()
}

function fokuszElso() {
  mezoRefek.value[0]?.focus()
}
defineExpose({ fokuszElso })

const elozetesSzoveg = computed(
  () =>
    ({
      nincs: '',
      helyes: 'Előzetes ellenőrzés: a szám helyesnek tűnik. A végső döntést a szerver hozza.',
      hibas: 'Előzetes ellenőrzés: a szám hibásnak tűnik. A végső döntést a szerver hozza.'
    })[props.elozetesEredmeny]
)
</script>

<template>
  <fieldset class="bevitel" :class="`bevitel--${elozetesEredmeny}`" @paste="beillesztesKezeles">
    <legend class="lathatatlan">Kártyaszám, 16 számjegy</legend>
    <div v-for="(csoport, c) in csoportok" :key="c" class="szamjegy-csoport">
      <input
        v-for="index in csoport"
        :key="index"
        :ref="(el) => (mezoRefek[index] = el)"
        :value="szamjegyek[index]"
        :aria-label="`${index + 1}. számjegy`"
        type="text"
        inputmode="numeric"
        maxlength="1"
        autocomplete="off"
        class="szamjegy-mezo"
        @input="bevitelKezeles(index, $event)"
        @keydown="billentyuKezeles(index, $event)"
        @focus="$event.target.select()"
      />
    </div>
    <p class="elozetes" aria-live="polite">{{ elozetesSzoveg }}</p>
  </fieldset>
</template>
