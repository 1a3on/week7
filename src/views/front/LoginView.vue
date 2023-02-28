<template>
    <div class="container">
        <div class="row justify-content-center">
          <div class="col-8">
            請先登入
            <form id="form" class="form-signin" @submit.prevent="login">
              <div class="form-floating mb-3">
                <input type="email" class="form-control" id="username" v-model="loginData.username"
                  placeholder="name@example.com" required autofocus>
                <label for="username">Email address</label>
              </div>
              <div class="form-floating">
                <input type="password" class="form-control" id="password" v-model="loginData.password"
                  placeholder="Password" required>
                <label for="password">Password</label>
              </div>
              <button class="btn btn-lg btn-primary w-100 mt-3" type="submit">
                登入
              </button>
            </form>
          </div>
      </div>
    </div>
</template>

<script>
const { VITE_APP_API } = import.meta.env

export default {
  data () {
    return {
      loginData: {
        username: '',
        password: ''
      }
    }
  },

  methods: {
    login () {
      this.$http.post(`${VITE_APP_API}/V2/admin/signin`, this.loginData)
        .then(res => {
          const { token, expired } = res.data
          document.cookie = `hexToken=${token};expires=${new Date(expired)}` // 寫入token、有效期間timestamp轉日期
          console.log('token:', token)
          this.$router.push('/admin/products')
        }).catch(err => { alert(err.data.message) })
    }
  },
  mounted () {
  }
}
</script>
