<template>
  <h2>一键整理</h2>
  <el-form :model="form" label-width="120px">
    <el-form-item label="STRM 目录">
      <el-input v-model="form.strmRoot" placeholder="/tmp/strm" />
    </el-form-item>
    <el-form-item label="输出目录">
      <el-input v-model="form.output" placeholder="~/StrmOrg" />
    </el-form-item>
    <el-form-item>
      <el-button type="primary" @click="onSubmit">开始整理</el-button>
    </el-form-item>
  </el-form>
</template>

<script setup lang="ts">
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { organize } from '@/api'

const form = reactive({ strmRoot: '', output: '' })

async function onSubmit() {
  await organize(form.strmRoot, form.output)
  ElMessage.success('整理任务已提交')
}
</script>
