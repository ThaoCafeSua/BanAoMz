package com.example.banaomz.repository.client;

import com.example.banaomz.dto.admin.sanPham.reponse.SanPhamDTO;
import com.example.banaomz.entity.admin.SanPham;
import com.example.banaomz.entity.client.IMauSacOption;
import com.example.banaomz.entity.client.IProductItemClient;
import com.example.banaomz.entity.client.ISizeOption;
import com.example.banaomz.entity.client.IVariantCombo;
import com.example.banaomz.repository.common.IBaseRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ISanPhamClientRepository extends IBaseRepository<SanPham, Long> {

    @Query(value = """
            SELECT
                sp.id                              AS id,
                sp.ma_san_pham                     AS maSanPham,
                sp.ten_san_pham                    AS tenSanPham,
                th.ten_thuong_hieu                 AS thuongHieu,
                xx.ten_xuat_xu                     AS xuatXu,
                dm.ten_danh_muc                    AS danhMuc,
                COALESCE(SUM(spct.so_luong), 0)    AS soLuong,
                sp.url_anh                         AS urlAnh,
                sp.trang_thai                      AS trangThai,
                sp.ngay_tao                        AS ngayTao,
                spct.gia_ban                       AS giaBan
            FROM san_pham sp
            LEFT JOIN san_pham_chi_tiet spct ON sp.id = spct.id_san_pham
            LEFT JOIN thuong_hieu th        ON sp.id_thuong_hieu = th.id
            LEFT JOIN xuat_xu xx            ON sp.id_xuat_xu   = xx.id
            LEFT JOIN danh_muc dm           ON sp.id_danh_muc  = dm.id
            WHERE (:search IS NULL OR sp.ten_san_pham LIKE CONCAT('%', :search, '%')
                           OR th.ten_thuong_hieu LIKE CONCAT('%', :search, '%'))
              AND (:status IS NULL OR sp.trang_thai LIKE CONCAT(:status, '%'))
            GROUP BY sp.id, sp.ma_san_pham, sp.ten_san_pham,
                     th.ten_thuong_hieu, xx.ten_xuat_xu, dm.ten_danh_muc,
                     sp.url_anh, sp.trang_thai, sp.ngay_tao, spct.gia_ban
            ORDER BY sp.ngay_tao DESC
            """, nativeQuery = true)
    List<IProductItemClient> getSanPhamMoiNhat(@Param("search") String search,
                                               @Param("status") String status);

    @Query(value = """
            SELECT TOP 10
                sp.id                              AS id,
                sp.ma_san_pham                     AS maSanPham,
                sp.ten_san_pham                    AS tenSanPham,
                th.ten_thuong_hieu                 AS thuongHieu,
                xx.ten_xuat_xu                     AS xuatXu,
                dm.ten_danh_muc                    AS danhMuc,
                COALESCE(SUM(spct.so_luong), 0)    AS soLuong,
                sp.url_anh                         AS urlAnh,
                sp.trang_thai                      AS trangThai,
                sp.ngay_tao                        AS ngayTao,
                spct.gia_ban                       AS giaBan,
                sp.so_luong_da_ban                 AS soLuongDaBan
            FROM san_pham sp
            LEFT JOIN san_pham_chi_tiet spct ON sp.id = spct.id_san_pham
            LEFT JOIN thuong_hieu th        ON sp.id_thuong_hieu = th.id
            LEFT JOIN xuat_xu xx            ON sp.id_xuat_xu   = xx.id
            LEFT JOIN danh_muc dm           ON sp.id_danh_muc  = dm.id
            GROUP BY sp.id, sp.ma_san_pham, sp.ten_san_pham,
                     th.ten_thuong_hieu, xx.ten_xuat_xu, dm.ten_danh_muc,
                     sp.url_anh, sp.trang_thai, sp.ngay_tao, spct.gia_ban, sp.so_luong_da_ban
            ORDER BY sp.so_luong_da_ban DESC
            """, nativeQuery = true)
    List<IProductItemClient> getTop10SanPhamBanChay();

    @Query(value = """
            SELECT
                sp.id                              AS id,
                sp.ma_san_pham                     AS maSanPham,
                sp.ten_san_pham                    AS tenSanPham,
                th.ten_thuong_hieu                 AS thuongHieu,
                xx.ten_xuat_xu                     AS xuatXu,
                dm.ten_danh_muc                    AS danhMuc,
                COALESCE(SUM(spct.so_luong), 0)    AS soLuong,
                sp.url_anh                         AS urlAnh,
                sp.trang_thai                      AS trangThai,
                sp.ngay_tao                        AS ngayTao,
                COALESCE(MIN(spct.gia_ban), 0)     AS giaBan,
                sp.so_luong_da_ban                 AS soLuongDaBan
            FROM san_pham sp
            LEFT JOIN san_pham_chi_tiet spct ON sp.id = spct.id_san_pham
            LEFT JOIN thuong_hieu th        ON sp.id_thuong_hieu = th.id
            LEFT JOIN xuat_xu xx            ON sp.id_xuat_xu   = xx.id
            LEFT JOIN danh_muc dm           ON sp.id_danh_muc  = dm.id
            WHERE sp.id = :id
            GROUP BY sp.id, sp.ma_san_pham, sp.ten_san_pham,
                     th.ten_thuong_hieu, xx.ten_xuat_xu, dm.ten_danh_muc,
                     sp.url_anh, sp.trang_thai, sp.ngay_tao, spct.gia_ban, sp.so_luong_da_ban
            """, nativeQuery = true)
    IProductItemClient getSanPhamById(@Param("id") Long id);

    @Query(value = """
            SELECT 
                ms.id                          AS id,
                ms.ten_mau_sac                 AS ten,
                COALESCE(SUM(spct.so_luong),0) AS soLuong
            FROM san_pham_chi_tiet spct
            JOIN mau_sac ms ON spct.id_mau_sac = ms.id
            WHERE spct.id_san_pham = :id
              AND (ms.trang_thai IS NULL OR ms.trang_thai LIKE 'HOAT_DONG')
            GROUP BY ms.id, ms.ten_mau_sac
            ORDER BY ms.ten_mau_sac
            """, nativeQuery = true)
    List<IMauSacOption> getMauSacBySanPhamId(@Param("id") Long id);

    @Query(value = """
            SELECT 
                s.id                           AS id,
                s.ten_size                     AS ten,
                COALESCE(SUM(spct.so_luong),0) AS soLuong
            FROM san_pham_chi_tiet spct
            JOIN size s ON spct.id_size = s.id
            WHERE spct.id_san_pham = :id
              AND (s.trang_thai IS NULL OR s.trang_thai LIKE 'HOAT_DONG%')
            GROUP BY s.id, s.ten_size
            ORDER BY s.ten_size
            """, nativeQuery = true)
    List<ISizeOption> getSizesBySanPhamId(@Param("id") Long id);

    @Query(value = """
            SELECT 
                spct.id_mau_sac AS mauId,
                spct.id_size    AS sizeId,
                COALESCE(SUM(spct.so_luong),0) AS soLuong
            FROM san_pham_chi_tiet spct
            WHERE spct.id_san_pham = :id
            GROUP BY spct.id_mau_sac, spct.id_size
            """, nativeQuery = true)
    List<IVariantCombo> getVariantCombos(@Param("id") Long id);

    @Query(value = """
  SELECT 
    spct.id         AS spctId,
    spct.id_mau_sac AS mauId,
    spct.id_size    AS sizeId,
    spct.so_luong   AS soLuong,
    spct.gia_ban    AS giaBan
  FROM san_pham_chi_tiet spct
  WHERE spct.id_san_pham = :id
  ORDER BY spct.id_mau_sac, spct.id_size
""", nativeQuery = true)
    List<com.example.banaomz.entity.client.IVariantItem> getVariantItems(@Param("id") Long id);

}
