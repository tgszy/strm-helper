<template>
  <el-card shadow="hover">
    <template #header>
      <span>{{ media.name }} ({{ media.year }})</span>
      <el-tag style="float: right">{{ media.type }}</el-tag>
    </template>
    <div v-for="v in media.versions" :key="v" class="version-item">
      <el-button size="small" type="primary" plain>{{ v }}</el-button>
    </div>
  </el-card>
</template>

<script setup lang="ts">
defineProps<{ media: any }>()
</script>

<style scoped>
.version-item { margin: 4px 0; }
</style>
