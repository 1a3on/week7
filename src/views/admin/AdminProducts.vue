<template>
  <h1>Admin Products</h1>
      <div class="container">
        <div class="text-end mt-4" ref='modal'>
          <button class="btn btn-primary" @click="openModal('create')">
            建立新的產品
          </button>
        </div>
        <table class="table mt-4">
          <thead>
            <tr>
              <th width="120">
                分類
              </th>
              <th>產品名稱</th>
              <th width="120">
                原價
              </th>
              <th width="120">
                售價
              </th>
              <th width="100">
                是否啟用
              </th>
              <th width="120">
                編輯
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in this.products" :key="item.id">
              <td>{{item.category}}</td>
              <td>{{item.title}}</td>
              <td class="text-end" style="text-align:justify !important">{{item.origin_price}}</td>
              <td class="text-end" style="text-align:justify !important">{{item.price}}</td>
              <td>
                <span v-if="item.is_enabled" class="text-success">啟用</span>
                <span v-else>未啟用</span>
              </td>
              <td>
                <div class="btn-group">
                  <button type="button" class="btn btn-outline-primary btn-sm" @click="openModal('edit',item)">
                    編輯
                  </button>
                  <button type="button" class="btn btn-outline-danger btn-sm" @click="openModal('delete',item)">
                    刪除
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
        <Pagination :pages="page" @emit-pages="getProducts"></Pagination>
        <ProductModal
          @update-product="updateProduct"
          :product="tempProduct"
          :isNew="isNew"
          ref="productModal"
        />
        <DelModal :item="tempProduct" ref="delModal" @del-item="deleteProduct"></DelModal>
      </div>
</template>

<script>
import Pagination from '@/components/PaginationItem.vue'
import DelModal from '@/components/DelModal.vue'
import ProductModal from '@/components/ProductModal.vue'
const { VITE_APP_API, VITE_APP_PATH } = import.meta.env
// let productModal = null
let delProductModal = null
let productModal = null
export default {
  data () {
    return {
      products: {},
      isNew: false,
      isLoading: false,
      itemDetail: {},
      tempProduct: {
        imagesUrl: []
      },
      status: {
        fileUploading: false
      },
      page: {},
      modal: {
        editModal: '',
        delModal: ''
      }
    }
  },
  components: {
    ProductModal,
    Pagination,
    DelModal
  },
  methods: {
    checkLogin () { // 登入驗證
      this.$http.post('/v2/api/user/check')
        .then(res => {
          console.log(`logsussess:${res}`)
          this.getProducts()
        })
        .catch(err => {
          console.log(`no login:${err.response.data.message}`) // 失敗跳轉回登入頁面
          // alert(err.response.data.message)
          this.$router.push('/login')
        })
    },
    getProducts (page = 1) {
      this.$http.get(`${VITE_APP_API}/v2/api/${VITE_APP_PATH}/admin/products?page=${page}`).then(res => {
        console.log('data:', res)
        this.products = res.data.products // 將api取得資料
        this.page = res.data.pagination
      })
        .catch(err => {
          console.log('getDataErr:', err.data.message)
        })
    },
    updateProducts () {
      let httpMethod = 'post'
      let api = `${VITE_APP_API}/v2/api/${VITE_APP_PATH}/admin/product`

      if (!this.isNew) {
        httpMethod = 'put'
        api = `${VITE_APP_API}/v2/api/${VITE_APP_PATH}/admin/product/${this.tempProduct.id}`
      }

      this.$hppt.$[httpMethod](api, { data: this.tempProduct })
        .then(res => {
          alert(`${res.data.message}`)
          console.log(res)
          // productModal.hide()
          this.getProducts()
        })
        .catch(err => {
          alert(`新增失敗:${err.data.message}`)
        })
    },
    updateProduct (item) {
      this.tempProduct = item
      let api = `${import.meta.env.VITE_APP_API}/api/${import.meta.env.VITE_APP_PATH}/admin/product`
      this.isLoading = true
      let httpMethod = 'post'
      let status = '新增產品'
      if (!this.isNew) {
        api = `${import.meta.env.VITE_APP_API}/api/${import.meta.env.VITE_APP_PATH}/admin/product/${this.tempProduct.id}`
        httpMethod = 'put'
        status = '更新產品'
      }
      const productComponent = this.$refs.productModal
      this.$http[httpMethod](api, { data: this.tempProduct }).then((response) => {
        this.isLoading = false
        // this.$httpMessageState(response, status)
        productComponent.hideModal()
        this.getProducts(this.currentPage)
      }).catch((error) => {
        this.isLoading = false
        this.$httpMessageState(error.response, status)
      })
    },
    createImages () { // 初始化
      this.tempProduct.imagesUrl = []
      this.tempProduct.imagesUrl.push('')
    },

    deleteProduct () {
      const api = `${VITE_APP_API}/v2/api/${VITE_APP_PATH}/admin/product/${this.tempProduct.id}`
      this.$http.delete(api)
        .then(res => {
          alert(res)
          delProductModal.hideModal()
          this.getProducts()
        })
        .catch(err => {
          alert(`刪除失敗:${err.data.message}`)
          delProductModal.hideModal()
        })
    },

    openModal (ced, item) {
      if (ced === 'create') {
        this.isNew = true
        this.tempProduct = {}
        productModal = this.$refs.productModal
        productModal.openModal()
      } else if (ced === 'edit') {
        this.isNew = false
        this.tempProduct = { ...item }
        productModal = this.$refs.productModal
        productModal.openModal()
      } else if (ced === 'delete') {
        this.tempProduct = { ...item }
        delProductModal = this.$refs.delModal
        delProductModal.openModal()
      }
    }

  },

  mounted () {
    const token = document.cookie.replace(/(?:(?:^|.*;\s*)hexToken\s*=\s*([^;]*).*$)|^.*$/, '$1') // 先取出tocken存入apititle，才能進行確認
    this.$http.defaults.headers.common.Authorization = token
    this.getProducts()
  }

}
</script>
