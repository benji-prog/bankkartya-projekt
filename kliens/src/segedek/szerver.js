import axios from 'axios'

export const szerver = axios.create({
  baseURL: import.meta.env.VITE_API_URL ?? '/api'
})
