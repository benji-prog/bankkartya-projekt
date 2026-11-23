<script setup>
import { computed } from 'vue'

const props = defineProps({
  eredmeny: { type: Object, default: null }
})

const megadottJegy = computed(() => props.eredmeny?.kartyaszam.at(-1))
</script>

<template>
  <div aria-live="polite">
    <section v-if="eredmeny" class="eredmeny">
      <p>
        Állapot:
        <strong :class="eredmeny.ervenyes ? 'helyes' : 'hibas'">
          {{ eredmeny.ervenyes ? 'Helyes bankkártyaszám' : 'Hibás bankkártyaszám' }}
        </strong>
        | Kártyatársaság: {{ eredmeny.kartyatarsasag }}
      </p>
      <p>Megadott ellenőrzőjegy: {{ megadottJegy }} | Luhn-összeg: {{ eredmeny.luhn_osszeg }}</p>
      <p v-if="!eredmeny.ervenyes">Elvárt ellenőrzőjegy: {{ eredmeny.elvart_ellenorzo_jegy }}</p>
    </section>
  </div>
</template>
