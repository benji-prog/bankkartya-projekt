export function kartyatarsasagMeghataroz(szam) {
  if (szam.length === 0) return ''
  if (szam[0] === '4') return 'Visa'
  if (szam.length < 2) return ''
  const elso2 = Number(szam.slice(0, 2))
  if (elso2 >= 51 && elso2 <= 55) return 'MasterCard'
  if (elso2 === 34 || elso2 === 37) return 'American Express'
  if (szam.length < 4) return elso2 >= 22 && elso2 <= 27 ? '' : 'Egyéb kártyatársaság'
  const elso4 = Number(szam.slice(0, 4))
  if (elso4 >= 2221 && elso4 <= 2720) return 'MasterCard'
  return 'Egyéb kártyatársaság'
}

export function luhnOsszeg(szam) {
  let osszeg = 0
  for (let i = 0; i < szam.length; i++) {
    let jegy = Number(szam[szam.length - 1 - i])
    if (i % 2 === 1) {
      jegy *= 2
      if (jegy > 9) jegy -= 9
    }
    osszeg += jegy
  }
  return osszeg
}

export function elvartEllenorzoJegy(elso15) {
  return (10 - (luhnOsszeg(elso15 + '0') % 10)) % 10
}

export function luhnEllenoriz(szam) {
  return /^\d{16}$/.test(szam) && luhnOsszeg(szam) % 10 === 0
}

function veletlenJegyek(darab) {
  let eredmeny = ''
  for (let i = 0; i < darab; i++) eredmeny += Math.floor(Math.random() * 10)
  return eredmeny
}

export function veletlenKartyaszam() {
  const elotag = Math.random() < 0.5 ? '4' : String(51 + Math.floor(Math.random() * 5))
  const elso15 = elotag + veletlenJegyek(15 - elotag.length)
  return elso15 + elvartEllenorzoJegy(elso15)
}

export function hibasKartyaszam() {
  const helyes = veletlenKartyaszam()
  const helyesJegy = Number(helyes[15])
  return helyes.slice(0, 15) + ((helyesJegy + 1) % 10)
}

export function maszkol(szam) {
  return szam.slice(0, 6) + '******' + szam.slice(-4)
}
