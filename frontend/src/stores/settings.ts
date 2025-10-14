
import { createRouter, createWebHistory } from 'vue-router'
import Home from './views/Home.vue'
import Settings from './views/Settings.vue'
import Organize from './views/Organize.vue'

const routes = [
  { path: '/', component: Home },
  { path: '/organize', component: Organize },
  { path: '/settings', component: Settings },
]
export default createRouter({ history: createWebHistory(), routes })
