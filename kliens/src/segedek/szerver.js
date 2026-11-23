import axios from 'axios'

export const szerver = axios.create({
  baseURL: 'http://localhost:8000/api',
})