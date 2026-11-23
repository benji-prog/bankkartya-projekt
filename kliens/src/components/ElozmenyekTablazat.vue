<script setup>
defineProps({
  elozmenyek: { type: Array, required: true }
})

function tagolt(szam) {
  return szam.match(/.{1,4}/g).join(' ')
}
</script>

<template>
  <section v-if="elozmenyek.length > 0" class="elozmenyek">
    <table>
      <caption>Legutóbbi ellenőrzések (legfeljebb 10, a legújabb elöl)</caption>
      <thead>
        <tr>
          <th scope="col">Kártyaszám</th>
          <th scope="col">Kártyatársaság</th>
          <th scope="col">Állapot</th>
          <th scope="col">Luhn-összeg</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="tetel in elozmenyek" :key="tetel.id">
          <td>{{ tagolt(tetel.kartyaszam) }}</td>
          <td>{{ tetel.kartyatarsasag }}</td>
          <td :class="tetel.ervenyes ? 'helyes' : 'hibas'">{{ tetel.ervenyes ? 'Helyes' : 'Hibás' }}</td>
          <td>{{ tetel.luhn_osszeg }}</td>
        </tr>
      </tbody>
    </table>
  </section>
</template>
