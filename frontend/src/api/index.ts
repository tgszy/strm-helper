import axios from 'axios'
export const api = axios.create({ baseURL: '/api' })

// ====== Mock 数据（等后端就位后删除） ======
export const MOCK_MEDIA = [
  { id: 1, name: '肖申克的救赎', year: 1994, type: 'movie', versions: ['1080p', '4K'] },
  { id: 2, name: '甄嬛传', year: 2011, type: 'tv', versions: ['v1', 'v2'] },
]

export const mockList = () => Promise.resolve({ data: MOCK_MEDIA })
export const mockSaveSetting = (data: any) => Promise.resolve({ data })
