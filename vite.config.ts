import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig(({ command, mode})=>{
  if (mode == "prod")
  return{
    plugins: [react()],
    port:8080,
    base: "./"
  }
  else
    return{
      plugins: [react()],
      base: "/PageAction/",
      port:8080
    }
})
