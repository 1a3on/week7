<template>
    這是購物車
    <table class="table align-middle">
            <thead>
              <tr>
                <th></th>
                <th>品名</th>
                <th style="width: 150px">數量/單位</th>
                <th class="text-end">單價</th>
              </tr>
            </thead>
            <tbody>
              <template v-if="cart.carts">
                <tr v-for="item in cart.carts" :key="item.id">
                  <td>
                    <button type="button" class="btn btn-outline-danger btn-sm" @click="deleteItem(item)" :disabled="item.id===loadingItem">
                      <i class="fas fa-spinner fa-pulse" v-if="this.deleteItemIsLoading"></i>
                      x
                    </button>
                  </td>
                  <td>
                    {{ item.product.title }}
                    <div class="text-success">
                      已套用優惠券
                    </div>
                  </td>
                  <td>
                    <div class="input-group input-group-sm">
                      <div class="input-group mb-3">
                        <select name=""  id="" class="form-select" v-model="item.qty" @change="updateCart(item)" :disabled="item.id===loadingItem">
                          <option :value="i" v-for="i in 20" :key="`${i}123456`">{{i}}</option>
                        </select>
                        <span class="input-group-text" id="basic-addon2">{{ item.product.unit }}</span>
                      </div>
                    </div>
                  </td>

                  <td class="text-end">
                    <small class="text-success">折扣價：</small>
                    {{ item.product.price }}
                  </td>
                </tr>
              </template>
            </tbody>
            <tfoot>
              <tr>
                <td colspan="3" class="text-end">總計</td>
                <td class="text-end">{{ cart.total }}</td>
              </tr>
              <tr>
                <td colspan="3" class="text-end text-success">折扣價</td>
                <td class="text-end text-success">{{ cart.final_total }}</td>
              </tr>
            </tfoot>
    </table>

</template>

<script>

const { VITE_APP_API, VITE_APP_PATH } = import.meta.env

export default {

  data () {
    return {
      productId: '',
      products: [],
      cart: {},
      loadingItem: '',
      infoIsLoading: false,
      addToCartIsLoading: false,
      deleteItemIsLoading: false
    }
  },
  methods: {
    getCart () {
      this.$http.get(`${VITE_APP_API}/v2/api/${VITE_APP_PATH}/cart`)
        .then(res => {
          this.cart = res.data.data
        })
    },
    updateCart (item) {
      this.loadingItem = item.id

      const data = {
        product_id: item.product.id,
        qty: item.qty
      }

      this.$http.put(`${VITE_APP_API}/v2/api/${VITE_APP_PATH}/cart/${item.id}`, { data })
        .then(res => {
          this.loadingItem = ''
          this.getCart()
        })
    },
    deleteItem (item) {
      this.loadingItem = item.id
      this.deleteItemIsLoading = true

      this.$http.delete(`${VITE_APP_API}/v2/api/${VITE_APP_PATH}/cart/${item.id}`)
        .then(res => {
          this.loadingItem = ''
          this.getCart()
          this.deleteItemIsLoading = false
        })
    },
    createOrder () {
      if (this.cart === '') {
        alert('請加入購買品項!')
      } else {
        alert('送出成功!')
        this.cart = ''
      }
    }

  },
  mounted () {
    this.getCart()
  }

}
</script>
