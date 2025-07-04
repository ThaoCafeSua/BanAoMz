<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container mt-4">
    <div class="border rounded-4 shadow-sm p-4">
        <div class="d-flex align-items-center mb-4">
            <i class="fas fa-file-invoice fa-2x me-2 text-primary"></i>
            <h4 class="mb-0 fw-bold">Chi Tiết Hóa Đơn -
                <c:out value="${hoaDonDetail.maHoaDon}" default="Không có"/>
            </h4>
        </div>
        <div class="card-body">
            <div class="row mb-3">
                <div class="col-md-6">
                    <p><strong>Mã hóa đơn:</strong> <c:out value="${hoaDonDetail.maHoaDon}" default="Không có"/></p>

                    <p><strong>Loại hóa đơn:</strong>
                        <c:choose>
                            <c:when test="${hoaDonDetail.loaiHoaDon == 'TAI_QUAY'}">
                                <span class="badge bg-info">Bán tại quầy</span>
                            </c:when>
                            <c:when test="${hoaDonDetail.loaiHoaDon == 'ONLINE'}">
                                <span class="badge bg-warning text-dark">Bán online</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Không rõ</span>
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <p><strong>Trạng thái:</strong>
                        <c:choose>
                            <c:when test="${hoaDonDetail.trangThai == 'CHO_THANH_TOAN'}">
                                <span class="badge bg-warning text-dark">Chờ thanh toán</span>
                            </c:when>
                            <c:when test="${hoaDonDetail.trangThai == 'DA_THANH_TOAN'}">
                                <span class="badge bg-success">Đã thanh toán</span>
                            </c:when>
                            <c:when test="${hoaDonDetail.trangThai == 'DA_HUY'}">
                                <span class="badge bg-danger">Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">Không rõ</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <p><strong>Ngày đặt:</strong>
                        <c:out value="${hoaDonDetail.ngayDat}" default="Không có"/>
                    </p>
                </div>

                <div class="col-md-6">
                    <p><strong>Khách hàng:</strong> <c:out value="${hoaDonDetail.tenKhachHang}" default="Không có"/></p>
                    <p><strong>Người nhận:</strong> <c:out value="${hoaDonDetail.tenNguoiNhan}" default="Không có"/></p>
                    <p><strong>Điện thoại:</strong> <c:out value="${hoaDonDetail.soDienThoaiNguoiNhan}" default="Không có"/></p>
                    <p><strong>Địa chỉ nhận:</strong> <c:out value="${hoaDonDetail.diaChiNguoiNhan}" default="Không có"/></p>
                </div>
            </div>

            <h5>Danh sách sản phẩm</h5>
            <c:choose>
                <c:when test="${empty hoaDonDetail.chiTietSanPhamList}">
                    <p>Không có sản phẩm nào.</p>
                </c:when>
                <c:otherwise>
                    <table class="table table-bordered">
                        <thead class="table-secondary">
                        <tr class="text-center">
                            <th>#</th>
                            <th>Sản phẩm</th>
                            <th>Màu sắc</th>
                            <th>Size</th>
                            <th>Đơn giá</th>
                            <th>Số lượng</th>
                            <th>Thành tiền</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="ct" items="${hoaDonDetail.chiTietSanPhamList}" varStatus="i">
                            <tr class="text-center">
                                <td>${i.index + 1}</td>
                                <td><c:out value="${ct.tenSanPham}" default="Không có"/></td>
                                <td><c:out value="${ct.mauSac}" default="Không có"/></td>
                                <td><c:out value="${ct.size}" default="Không có"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${ct.giaBan != null}">
                                            <fmt:formatNumber value="${ct.giaBan}" type="currency" currencySymbol="₫"/>
                                        </c:when>
                                        <c:otherwise>Không có</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${ct.soLuong}" default="0"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${ct.thanhTien != null}">
                                            <fmt:formatNumber value="${ct.thanhTien}" type="currency" currencySymbol="₫"/>
                                        </c:when>
                                        <c:otherwise>Không có</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>

            <div class="mt-4 text-end">
                <p><strong>Tổng tiền:</strong>
                    <c:choose>
                        <c:when test="${hoaDonDetail.tongTien != null}">
                            <fmt:formatNumber value="${hoaDonDetail.tongTien}" type="currency" currencySymbol="₫"/>
                        </c:when>
                        <c:otherwise>Không có</c:otherwise>
                    </c:choose>
                </p>

                <p><strong>Tiền giảm:</strong>
                    <c:choose>
                        <c:when test="${hoaDonDetail.tienGiam != null}">
                            <fmt:formatNumber value="${hoaDonDetail.tienGiam}" type="currency" currencySymbol="₫"/>
                        </c:when>
                        <c:otherwise>Không có</c:otherwise>
                    </c:choose>
                </p>

                <p><strong>Phí vận chuyển:</strong>
                    <c:choose>
                        <c:when test="${hoaDonDetail.phiVanChuyen != null}">
                            <fmt:formatNumber value="${hoaDonDetail.phiVanChuyen}" type="currency" currencySymbol="₫"/>
                        </c:when>
                        <c:otherwise>Không có</c:otherwise>
                    </c:choose>
                </p>

                <h5><strong>Thành tiền:</strong>
                    <c:choose>
                        <c:when test="${hoaDonDetail.thanhTien != null}">
                            <fmt:formatNumber value="${hoaDonDetail.thanhTien}" type="currency" currencySymbol="₫"/>
                        </c:when>
                        <c:otherwise>Không có</c:otherwise>
                    </c:choose>
                </h5>
            </div>

            <a href="/admin/hoaDon/xuat-pdf/${hoaDonDetail.id}" class="btn btn-danger mt-3 ms-2">
                <i class="fa-solid fa-file-pdf"></i> Xuất hóa đơn PDF
            </a>


            <a href="/admin/hoaDon" class="btn btn-secondary mt-3"><i class="fa fa-arrow-left"></i> Quay lại danh sách</a>
        </div>
    </div>
</div>
