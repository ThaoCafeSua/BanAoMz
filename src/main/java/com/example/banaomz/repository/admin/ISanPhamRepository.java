package com.example.banaomz.repository.admin;

import com.example.banaomz.entity.admin.IProductItem;
import com.example.banaomz.entity.admin.SanPham;
import com.example.banaomz.entity.client.IProductItemClient;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ISanPhamRepository extends IBaseRepository<SanPham, Long> {

    @Query(value = """
            SELECT sp.id,
                   sp.ma_san_pham AS maSanPham,
                   sp.ten_san_pham AS sanPham,
                   th.ten_thuong_hieu AS thuongHieu,
                   xx.ten_xuat_xu AS xuatXu,
                   dm.ten_danh_muc AS danhMuc,
                   COALESCE(SUM(spct.so_luong), 0) AS soLuong,
                   sp.ngay_tao,
                   sp.trang_thai AS trangThai
            FROM san_pham sp
                     LEFT JOIN san_pham_chi_tiet spct ON sp.id = spct.id_san_pham
                     LEFT JOIN thuong_hieu th ON sp.id_thuong_hieu = th.id
                     LEFT JOIN xuat_xu xx ON sp.id_xuat_xu = xx.id
                     LEFT JOIN danh_muc dm ON sp.id_danh_muc = dm.id
            WHERE sp.ten_san_pham LIKE %:search%
              AND sp.trang_thai LIKE :status%
            GROUP BY sp.id, sp.ma_san_pham, sp.ten_san_pham, th.ten_thuong_hieu,
                     xx.ten_xuat_xu, dm.ten_danh_muc, sp.ngay_tao, sp.trang_thai
            ORDER BY sp.ngay_tao DESC
            """, nativeQuery = true)
    List<IProductItem> getLstProductGroup(@Param("search") String search, @Param("status") String status);

    @Query(value = """
            SELECT sp.id,
                   sp.ma_san_pham AS maSanPham,
                   sp.ten_san_pham AS tenSanPham,
                   sp.url_anh,
                   sp.ngay_tao,
                   MIN(spct.gia_ban) AS giaBanMin,
                   MAX(spct.gia_ban) AS giaBanMax,
                   sp.trang_thai
            FROM san_pham sp
                     JOIN san_pham_chi_tiet spct ON sp.id = spct.id_san_pham
            WHERE sp.trang_thai = 'HOAT_DONG'
            GROUP BY sp.id, sp.ma_san_pham, sp.ten_san_pham, sp.url_anh, sp.ngay_tao, sp.trang_thai
            ORDER BY sp.ngay_tao DESC
            """, nativeQuery = true)
    List<IProductItemClient> getLstProcutSiteClient();
}
