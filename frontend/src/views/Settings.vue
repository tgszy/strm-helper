<template>
  <h2>高级设置</h2>
  <el-form :model="settings" label-width="140px">
    <el-form-item label="最大版本数">
      <el-input-number v-model="settings.maxVersions" :min="1" :max="10"/>
    </el-form-item>
    <el-form-item label="命名模板">
      <el-input v-model="settings.namingTemplate"/>
    </el-form-item>
    <el-form-item>
      <el-button type="primary" @click="save">保存</el-button>
    </el-form-item>
  </el-form>
</template>

<script setup lang="ts">
import { useSettingsStore } from '@/stores/settings'
const settings = useSettingsStore()
function save() { ElMessage.success('已保存') }
</script>
