import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE,
  timeout: 10000
})

/* ====== Settings API ====== */
export const getSettings = () => api.get('/settings')
export const updateSettings = (data: any) => api.put('/settings', data)

/* ====== Media API ====== */
export const listMedia = () => api.get('/media')

/* ====== Organize API ====== */
export const organize = (strmRoot: string, output: string) =>
  api.post('/organize', { strm_root: strmRoot, output })
