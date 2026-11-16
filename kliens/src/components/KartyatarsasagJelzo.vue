<script setup>
import { computed } from 'vue'

const props = defineProps({
  kartyatarsasag: { type: String, required: true }
})

const megjelenitett = computed(() => props.kartyatarsasag || '–')
const amexFigyelmeztetes = computed(() => props.kartyatarsasag === 'American Express')
</script>

<template>
  <p class="jelzo" aria-live="polite">
    Felismert kártyatársaság: <strong>{{ megjelenitett }}</strong>
    <span v-if="amexFigyelmeztetes" class="figyelmeztetes">
      Az American Express kártyaszáma 15 jegyű, ezt az alkalmazás nem kezeli.
    </span>
  </p>
</template>
