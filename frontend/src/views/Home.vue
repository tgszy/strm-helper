<template>
  <div>
    <h2>媒体库总览</h2>
    <el-row :gutter="12">
      <el-col v-for="m in media" :key="m.id" :span="8">
        <VersionCard :media="m" />
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { listMedia } from '@/api'
import VersionCard from '@/components/VersionCard.vue'

const media = ref([])
onMounted(async () => {
  const { data } = await listMedia()
  media.value = data
})
</script>
