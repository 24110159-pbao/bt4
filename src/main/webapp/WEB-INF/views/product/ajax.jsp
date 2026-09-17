
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Quản lý Product</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            margin: 0;
            padding: 25px;
            color: #222;
        }

        .container {
            max-width: 1200px;
            margin: auto;
        }

        h1 {
            margin-bottom: 20px;
        }

        .nav {
            margin-bottom: 20px;
        }

        .nav a {
            display: inline-block;
            padding: 10px 16px;
            margin-right: 8px;
            background: #e2e8f0;
            color: #222;
            text-decoration: none;
            border-radius: 5px;
        }

        .nav a.active {
            background: #2563eb;
            color: white;
        }

        .panel {
            background: white;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px #0001;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        label {
            display: block;
            margin: 12px 0 6px;
            font-weight: bold;
        }

        input, select, textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-family: inherit;
        }

        textarea {
            min-height: 80px;
            resize: vertical;
        }

        button {
            padding: 9px 14px;
            border: 0;
            border-radius: 5px;
            cursor: pointer;
            margin: 4px 2px;
        }

        .primary {
            background: #2563eb;
            color: white;
        }

        .secondary {
            background: #64748b;
            color: white;
        }

        .edit {
            background: #f59e0b;
            color: white;
        }

        .delete {
            background: #dc2626;
            color: white;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }

        th {
            background: #eff6ff;
        }

        .preview {
            width: 120px;
            height: 120px;
            object-fit: cover;
            display: none;
            margin-top: 10px;
            border-radius: 6px;
        }

        .product-image {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 5px;
        }

        .message {
            margin-top: 12px;
            font-weight: bold;
        }

        @media(max-width: 750px) {
            body {
                padding: 10px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .panel {
                overflow-x: auto;
            }

            table {
                min-width: 900px;
            }
        }
    </style>
</head>

<body>
<div class="container">

    <h1>Quản lý Product</h1>

    <div class="nav">
        <a href="${pageContext.request.contextPath}/category">
            Category
        </a>

        <a href="${pageContext.request.contextPath}/product"
           class="active">
            Product
        </a>
    </div>

    <div class="panel">
        <h2 id="formTitle">Thêm Product</h2>

        <form id="productForm"
              enctype="multipart/form-data">

            <input type="hidden" id="productId">

            <div class="form-grid">

                <div>
                    <label for="productName">
                        Tên Product
                    </label>

                    <input type="text"
                           id="productName"
                           required>
                </div>

                <div>
                    <label for="categoryId">
                        Category
                    </label>

                    <select id="categoryId" required>
                        <option value="">
                            -- Chọn Category --
                        </option>
                    </select>
                </div>

                <div>
                    <label for="unitPrice">
                        Đơn giá
                    </label>

                    <input type="number"
                           id="unitPrice"
                           min="0"
                           step="0.01"
                           required>
                </div>

                <div>
                    <label for="discount">
                        Giảm giá
                    </label>

                    <input type="number"
                           id="discount"
                           min="0"
                           step="0.01"
                           value="0"
                           required>
                </div>

                <div>
                    <label for="quantity">
                        Số lượng
                    </label>

                    <input type="number"
                           id="quantity"
                           min="0"
                           value="0"
                           required>
                </div>

                <div>
                    <label for="status">
                        Trạng thái
                    </label>

                    <select id="status" required>
                        <option value="1">Đang bán</option>
                        <option value="0">Ngừng bán</option>
                    </select>
                </div>

            </div>

            <label for="description">
                Mô tả
            </label>

            <textarea id="description"></textarea>

            <label for="imageFile">
                Ảnh Product
            </label>

            <input type="file"
                   id="imageFile"
                   accept="image/*">

            <img id="preview"
                 class="preview"
                 alt="Ảnh xem trước">

            <br><br>

            <button type="submit"
                    class="primary"
                    id="saveButton">
                Thêm Product
            </button>

            <button type="button"
                    class="secondary"
                    onclick="resetForm()">
                Làm mới
            </button>

        </form>

        <div id="message" class="message"></div>
    </div>

    <div class="panel">
        <h2>Danh sách Product</h2>

        <button class="primary"
                onclick="loadProducts()">
            Tải lại danh sách
        </button>

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên Product</th>
                <th>Category</th>
                <th>Đơn giá</th>
                <th>Giảm giá</th>
                <th>Số lượng</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>

            <tbody id="productTable">
            </tbody>
        </table>
    </div>

</div>

<script>
    const contextPath =
        '${pageContext.request.contextPath}';

    const productApi = contextPath + '/api/product';
    const categoryApi = contextPath + '/api/category';

    const productImageUrl =
        contextPath + '/product-images/';

    const form = document.getElementById('productForm');
    const message = document.getElementById('message');

    let products = [];
    let categories = [];

    function showMessage(text, success) {
        message.textContent = text;
        message.style.color = success ? 'green' : 'red';
    }

    async function loadCategories() {
        try {
            const response = await fetch(categoryApi);
            const result = await response.json();

            if (!response.ok || !result.success) {
                throw new Error(result.message ||
                    'Không tải được Category');
            }

            categories = result.data || [];

            const select =
                document.getElementById('categoryId');

            const currentValue = select.value;

            select.innerHTML = `
                <option value="">
                    -- Chọn Category --
                </option>
            `;

            categories.forEach(category => {
                const option = document.createElement('option');

                option.value = category.categoryId;
                option.textContent = category.categoryName;

                select.appendChild(option);
            });

            if (currentValue) {
                select.value = currentValue;
            }

        } catch (error) {
            showMessage(error.message, false);
        }
    }

    async function loadProducts() {
        try {
            const response = await fetch(productApi);
            const result = await response.json();

            if (!response.ok || !result.success) {
                throw new Error(result.message ||
                    'Không tải được Product');
            }

            products = result.data || [];

            renderProducts();

        } catch (error) {
            showMessage(error.message, false);
        }
    }

    function renderProducts() {
        const tbody = document.getElementById('productTable');
        tbody.innerHTML = '';

        products.forEach(product => {
            const tr = document.createElement('tr');

            const tdId = document.createElement('td');
            tdId.textContent = product.productId;

            const tdImage = document.createElement('td');

            if (product.images) {
                const img = document.createElement('img');
                img.className = 'product-image';
                img.src = productImageUrl +
                    encodeURIComponent(product.images);
                img.alt = 'Product';
                tdImage.appendChild(img);
            } else {
                tdImage.textContent = 'Chưa có ảnh';
            }

            const tdName = document.createElement('td');
            tdName.textContent = product.productName || '';

            const tdCategory = document.createElement('td');
            tdCategory.textContent = product.categoryName || '';

            const tdPrice = document.createElement('td');
            tdPrice.textContent = product.unitPrice ?? '';

            const tdDiscount = document.createElement('td');
            tdDiscount.textContent = product.discount ?? '';

            const tdQuantity = document.createElement('td');
            tdQuantity.textContent = product.quantity ?? '';

            const tdStatus = document.createElement('td');
            tdStatus.textContent =
                Number(product.status) === 1
                    ? 'Đang bán'
                    : 'Ngừng bán';

            const tdAction = document.createElement('td');

            const editButton = document.createElement('button');
            editButton.className = 'edit';
            editButton.textContent = 'Sửa';
            editButton.onclick = () =>
                editProduct(product.productId);

            const deleteButton = document.createElement('button');
            deleteButton.className = 'delete';
            deleteButton.textContent = 'Xóa';
            deleteButton.onclick = () =>
                deleteProduct(product.productId);

            tdAction.appendChild(editButton);
            tdAction.appendChild(deleteButton);

            tr.appendChild(tdId);
            tr.appendChild(tdImage);
            tr.appendChild(tdName);
            tr.appendChild(tdCategory);
            tr.appendChild(tdPrice);
            tr.appendChild(tdDiscount);
            tr.appendChild(tdQuantity);
            tr.appendChild(tdStatus);
            tr.appendChild(tdAction);

            tbody.appendChild(tr);
        });
    }

    document.getElementById('imageFile')
        .addEventListener('change', function () {

            const file = this.files[0];
            const preview = document.getElementById('preview');

            if (file) {
                preview.src = URL.createObjectURL(file);
                preview.style.display = 'block';
            } else {
                preview.src = '';
                preview.style.display = 'none';
            }
        });

    function resetForm() {
        form.reset();

        document.getElementById('productId').value = '';

        document.getElementById('formTitle').textContent =
            'Thêm Product';

        document.getElementById('saveButton').textContent =
            'Thêm Product';

        const preview = document.getElementById('preview');

        preview.src = '';
        preview.style.display = 'none';

        message.textContent = '';
    }

    form.addEventListener('submit', async function (event) {
        event.preventDefault();

        const id =
            document.getElementById('productId').value;

        const formData = new FormData();

        formData.append(
            'productName',
            document.getElementById('productName')
                .value.trim()
        );

        formData.append(
            'categoryId',
            document.getElementById('categoryId').value
        );

        formData.append(
            'unitPrice',
            document.getElementById('unitPrice').value
        );

        formData.append(
            'discount',
            document.getElementById('discount').value
        );

        formData.append(
            'description',
            document.getElementById('description').value
        );

        formData.append(
            'quantity',
            document.getElementById('quantity').value
        );

        formData.append(
            'status',
            document.getElementById('status').value
        );

        const imageFile =
            document.getElementById('imageFile').files[0];

        if (imageFile) {
            formData.append('imageFile', imageFile);
        }

        const url = id
            ? productApi + "/" + id
            : productApi;

        const method = id ? 'PUT' : 'POST';

        try {
            const response = await fetch(url, {
                method: method,
                body: formData
            });

            const result = await response.json();

            if (!response.ok || !result.success) {
                throw new Error(result.message ||
                    'Có lỗi xảy ra');
            }

            showMessage(result.message, true);

            resetForm();

            await loadProducts();

        } catch (error) {
            showMessage(error.message, false);
        }
    });

    function editProduct(id) {
        const product = products.find(
            item => item.productId === id
        );

        if (!product) return;

        document.getElementById('productId').value =
            product.productId;

        document.getElementById('productName').value =
            product.productName || '';

        document.getElementById('categoryId').value =
            product.categoryId || '';

        document.getElementById('unitPrice').value =
            product.unitPrice ?? 0;

        document.getElementById('discount').value =
            product.discount ?? 0;

        document.getElementById('description').value =
            product.description || '';

        document.getElementById('quantity').value =
            product.quantity ?? 0;

        document.getElementById('status').value =
            product.status ?? 1;

        document.getElementById('formTitle').textContent =
            'Cập nhật Product';

        document.getElementById('saveButton').textContent =
            'Cập nhật Product';

        const preview = document.getElementById('preview');

        if (product.images) {
            preview.src = productImageUrl +
                encodeURIComponent(product.images);

            preview.style.display = 'block';
        } else {
            preview.src = '';
            preview.style.display = 'none';
        }

        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    async function deleteProduct(id) {
        if (!confirm('Bạn có chắc muốn xóa Product này?')) {
            return;
        }

        try {
            const response = await fetch(
                productApi + "/" + id,
                { method: 'DELETE' }
            );

            const result = await response.json();

            if (!response.ok || !result.success) {
                throw new Error(result.message ||
                    'Không thể xóa Product');
            }

            showMessage(result.message, true);

            await loadProducts();

        } catch (error) {
            showMessage(error.message, false);
        }
    }

    async function init() {
        await loadCategories();
        await loadProducts();
    }

    init();
</script>
</body>
</html>