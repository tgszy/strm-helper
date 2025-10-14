<template>
  <h2>高级设置</h2>
  <el-form :model="form" label-width="140px">
    <el-form-item label="最大版本数">
      <el-input-number v-model="form.maxVersions" :min="1" :max="10" />
    </el-form-item>
    <el-form-item label="命名模板">
      <el-input v-model="form.namingTemplate" />
    </el-form-item>
    <el-form-item>
      <el-button type="primary" @click="save">保存</el-button>
    </el-form-item>
  </el-form>
</template>

<script setup lang="ts">
import { reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getSettings, updateSettings } from '@/api'

const form = reactive({ maxVersions: 3, namingTemplate: '' })

onMounted(async () => {
  const { data } = await getSettings()
  form.maxVersions = data.max_versions
  form.namingTemplate = data.naming_template
})

async function save() {
  await updateSettings({ max_versions: form.maxVersions, naming_template: form.namingTemplate })
  ElMessage.success('已保存')
}
</script>
