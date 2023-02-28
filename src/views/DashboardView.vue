<template>
    這是後台頁面
    <router-link to="/admin/orders">訂單列表</router-link>|
    <router-link to="/admin/products">產品列表</router-link>|
    <router-link to="/">返回前台</router-link>|
    <a href="#" @click.prevent="logout">登出</a>
    <hr>
    <RouterView></RouterView>
</template>

<script>
import { RouterView } from 'vue-router'
const { VITE_APP_API } = import.meta.env

export default {
  components: {
    RouterView
  },
  methods: {
    logout () {
      document.cookie = `hexToken=;expires=${new Date()}`
      this.$router.push('/login')
    },
    checkLogin () { // 登入驗證
      const token = document.cookie.replace(/(?:(?:^|.*;\s*)hexToken\s*=\s*([^;]*).*$)|^.*$/, '$1') // 先取出tocken存入apititle，才能進行確認
      this.$http.defaults.headers.common.Authorization = token
      const api = `${VITE_APP_API}/api/user/check`
      console.log(`token:${token}`)
      this.$http.post(api)
        .then((res) => {
          console.log(res)
          if (!res.data.success) {
            this.$router.push('/login')
          }
          // this.getProducts()
        })
        .catch(err => {
          console.log(`no login:${err.response.data.message}`) // 失敗跳轉回登入頁面
          alert(err.response.data.message)
          this.$router.push('/login')
        })
    }
  },
  mounted () {
    this.checkLogin()
  }
}

</script>
