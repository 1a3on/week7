<template>
    這是單項頁面
  <h2>{{ this.product.title }}</h2>
  <img :src="this.product.imageUrl" class="img-fluid">
</template>

<script>
const { VITE_APP_API, VITE_APP_PATH } = import.meta.env
export default {
  data () {
    return {
      product: {}
    }
  },
  methods: {
    getProduct () {
      const { id } = this.$route.params
      this.$http.get(`${VITE_APP_API}/v2/api/${VITE_APP_PATH}/product/${id}`)
        .then((res) => {
          this.product = res.data.product
        })
    }
  },
  mounted () {
    this.getProduct()
  }
}
</script>
