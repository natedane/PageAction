import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig(({ command, mode})=>{
  if ('build-production')
  return{
    plugins: [react()],
    base: "./"
  }
  else
    return{
      plugins: [react()],
      base: "/PageAction/"
    }
})
