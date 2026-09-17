
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Quản lý Category</title>

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
            max-width: 1100px;
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

        label {
            display: block;
            margin: 12px 0 6px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
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
            padding: 12px;
            text-align: left;
        }

        th {
            background: #eff6ff;
        }

        .preview {
            width: 100px;
            height: 100px;
            object-fit: cover;
            display: none;
            margin-top: 10px;
            border-radius: 6px;
        }

        .category-image {
            width: 65px;
            height: 65px;
            object-fit: cover;
            border-radius: 5px;
        }

        .message {
            margin-top: 12px;
            font-weight: bold;
        }

        @media(max-width: 650px) {
            body {
                padding: 10px;
            }

            .panel {
                overflow-x: auto;
            }

            table {
                min-width: 550px;
            }
        }
    </style>
</head>

<body>
<div class="container">

    <h1>Quản lý Category</h1>

    <div class="nav">
        <a href="${pageContext.request.contextPath}/category"
           class="active">Category</a>

        <a href="${pageContext.request.contextPath}/product">
            Product
        </a>
    </div>

    <div class="panel">
        <h2 id="formTitle">Thêm Category</h2>

        <form id="categoryForm"
              enctype="multipart/form-data">

            <input type="hidden" id="categoryId">

            <label for="categoryName">Tên Category</label>
            <input type="text"
                   id="categoryName"
                   required
                   placeholder="Nhập tên danh mục">

            <label for="imageFile">Ảnh Category</label>
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
                Thêm Category
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
        <h2>Danh sách Category</h2>

        <button class="primary"
                onclick="loadCategories()">
            Tải lại danh sách
        </button>

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên Category</th>
                <th>Thao tác</th>
            </tr>
            </thead>

            <tbody id="categoryTable">
            </tbody>
        </table>
    </div>

</div>

<script>
    const contextPath =
        '${pageContext.request.contextPath}';

    const apiUrl = contextPath + '/api/category';

    const imageUrl = contextPath + '/category-images/';

    const form = document.getElementById('categoryForm');
    const message = document.getElementById('message');

    let categories = [];

    function showMessage(text, success) {
        message.textContent = text;
        message.style.color = success ? 'green' : 'red';
    }

    function resetForm() {
        form.reset();

        document.getElementById('categoryId').value = '';
        document.getElementById('formTitle').textContent =
            'Thêm Category';

        document.getElementById('saveButton').textContent =
            'Thêm Category';

        const preview = document.getElementById('preview');
        preview.src = '';
        preview.style.display = 'none';

        message.textContent = '';
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

    async function loadCategories() {
        try {
            const response = await fetch(apiUrl);
            const result = await response.json();

            if (!response.ok || !result.success) {
                throw new Error(result.message ||
                    'Không tải được danh sách');
            }

            categories = result.data || [];

            renderCategories();

            // Cập nhật dropdown Category ở trang Product
            localStorage.setItem(
                'categoryList',
                JSON.stringify(categories)
            );

        } catch (error) {
            showMessage(error.message, false);
        }
    }

    function renderCategories() {
        const tbody = document.getElementById('categoryTable');
        tbody.innerHTML = '';

        categories.forEach(category => {
            const tr = document.createElement('tr');

            const tdId = document.createElement('td');
            tdId.textContent = category.categoryId;

            const tdImage = document.createElement('td');

            if (category.icon) {
                const img = document.createElement('img');
                img.className = 'category-image';
                img.src = imageUrl + encodeURIComponent(category.icon);
                img.alt = 'Category';
                tdImage.appendChild(img);
            } else {
                tdImage.textContent = 'Chưa có ảnh';
            }

            const tdName = document.createElement('td');
            tdName.textContent = category.categoryName || '';

            const tdAction = document.createElement('td');

            const editButton = document.createElement('button');
            editButton.className = 'edit';
            editButton.textContent = 'Sửa';
            editButton.onclick = () =>
                editCategory(category.categoryId);

            const deleteButton = document.createElement('button');
            deleteButton.className = 'delete';
            deleteButton.textContent = 'Xóa';
            deleteButton.onclick = () =>
                deleteCategory(category.categoryId);

            tdAction.appendChild(editButton);
            tdAction.appendChild(deleteButton);

            tr.appendChild(tdId);
            tr.appendChild(tdImage);
            tr.appendChild(tdName);
            tr.appendChild(tdAction);

            tbody.appendChild(tr);
        });
    }

    form.addEventListener('submit', async function (event) {
        event.preventDefault();

        const id =
            document.getElementById('categoryId').value;

        const categoryName =
            document.getElementById('categoryName')
                .value.trim();

        const imageFile =
            document.getElementById('imageFile').files[0];

        if (!categoryName) {
            showMessage('Vui lòng nhập tên Category', false);
            return;
        }

        const formData = new FormData();

        formData.append('categoryName', categoryName);

        if (imageFile) {
            formData.append('imageFile', imageFile);
        }

        const url = id ? apiUrl + "/" + id : apiUrl;
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

            await loadCategories();

        } catch (error) {
            showMessage(error.message, false);
        }
    });

    function editCategory(id) {
        const category = categories.find(
            item => item.categoryId === id
        );

        if (!category) return;

        document.getElementById('categoryId').value =
            category.categoryId;

        document.getElementById('categoryName').value =
            category.categoryName || '';

        document.getElementById('formTitle').textContent =
            'Cập nhật Category';

        document.getElementById('saveButton').textContent =
            'Cập nhật Category';

        const preview = document.getElementById('preview');

        if (category.icon) {
            preview.src = imageUrl +
                encodeURIComponent(category.icon);

            preview.style.display = 'block';
        } else {
            preview.src = '';
            preview.style.display = 'none';
        }

        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    async function deleteCategory(id) {
        const confirmed = confirm(
            'Bạn có chắc muốn xóa Category này?'
        );

        if (!confirmed) return;

        try {
            const response = await fetch(
                apiUrl + "/" + id,
                { method: 'DELETE' }
            );

            const result = await response.json();

            if (!response.ok || !result.success) {
                throw new Error(result.message ||
                    'Không thể xóa Category');
            }

            showMessage(result.message, true);

            await loadCategories();

        } catch (error) {
            showMessage(error.message, false);
        }
    }

    loadCategories();
</script>
</body>
</html>