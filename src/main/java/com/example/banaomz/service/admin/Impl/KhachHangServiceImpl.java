package com.example.banaomz.service.admin.Impl;

import com.example.banaomz.dto.admin.diaChi.DiaChiDTO;
import com.example.banaomz.dto.admin.khachHang.KhachHangDTO;
import com.example.banaomz.dto.admin.mail.MailInputDTO;
import com.example.banaomz.entity.admin.DiaChi;
import com.example.banaomz.entity.admin.KhachHang;
import com.example.banaomz.exception.AppException;
import com.example.banaomz.exception.ErrorCode;
import com.example.banaomz.repository.admin.IKhachHangRepository;
import com.example.banaomz.service.admin.IDiaChiService;
import com.example.banaomz.service.admin.IKhachHangService;
import com.example.banaomz.service.common.IMailService;
import com.example.banaomz.service.common.impl.BaseServiceImpl;
import com.example.banaomz.ultiltes.RandomStringGenerator;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@Service
public class KhachHangServiceImpl extends BaseServiceImpl<KhachHang, Long, IKhachHangRepository>
        implements IKhachHangService {

    @Autowired
    ModelMapper modelMapper;

    @Autowired
    PasswordEncoder passwordEncoder;

    @Autowired
    RandomStringGenerator randomStringGenerator;

    @Autowired
    IDiaChiService diaChiService;

    @Autowired
    private IMailService mailService;
    @Override
    public List<KhachHangDTO> findAllCustomer(String value) {
        List<KhachHangDTO> lst = repository.findAllCustomer(value).stream()
                .map(item -> modelMapper.map(item, KhachHangDTO.class)).toList();
        return lst;
    }

    @Override
    public KhachHangDTO createCustomer(KhachHangDTO khachHangDTO) {
        String password = randomStringGenerator.generateRandomString(8);
        CompletableFuture<KhachHangDTO> saveTask = CompletableFuture.supplyAsync(() -> {
            KhachHang entity = modelMapper.map(khachHangDTO, KhachHang.class);
            entity.setMatKhau(passwordEncoder.encode(password));
            createNew(entity);
            return khachHangDTO;
        });
        saveTask.thenRunAsync(() -> {
            if (khachHangDTO.getEmail() != null) {
                MailInputDTO mailInput = new MailInputDTO();
                mailInput.setEmail(khachHangDTO.getEmail());
                mailInput.setPassword(password);
                mailInput.setName(khachHangDTO.getHoVaTen());
                mailService.create(mailInput);
            }
        });
        return saveTask.join();
    }


    @Override
    public KhachHangDTO updateCustomer(KhachHangDTO khachHangDTO) {
        KhachHang entity = findById(khachHangDTO.getId()).
                orElseThrow(() -> new AppException(ErrorCode.INVALID_REQUEST));
        modelMapper.map(khachHangDTO, entity);
        update(entity);
        return khachHangDTO;
    }

    @Override
    public KhachHangDTO detailCustomer(Long customerId) {
        KhachHang entity = findById(customerId).
                orElseThrow(() -> new AppException(ErrorCode.INVALID_REQUEST));
        KhachHangDTO khachHangDTO = modelMapper.map(entity, KhachHangDTO.class);
        List<DiaChiDTO> lstAddRess = diaChiService.getLstAddressByCustomer(customerId);
        khachHangDTO.setLstDiaChi(lstAddRess);
        return khachHangDTO;
    }

    @Override
    @Transactional
    public DiaChiDTO addressCustomer(DiaChiDTO req) {
        KhachHang entity = findById(req.getCustomerId()).
                orElseThrow(() -> new AppException(ErrorCode.INVALID_REQUEST));
        List<DiaChi> lstDiaChi = entity.getLstDiaChi().stream().toList();
        if (req.getId() == null){
            DiaChi diaChi = modelMapper.map(req, DiaChi.class);
            diaChi.setKhachHang(entity);
            if (diaChi.getDiaChiMacDinh()){
                lstDiaChi.stream().forEach(item -> item.setDiaChiMacDinh(false));
            }
            diaChiService.createNew(diaChi);
        }else {
            DiaChi diaChi = diaChiService.findById(req.getId())
                    .orElseThrow(() -> new AppException(ErrorCode.INVALID_REQUEST));
            modelMapper.map(req, diaChi);
            if (diaChi.getDiaChiMacDinh()){
                lstDiaChi.stream().forEach(item -> item.setDiaChiMacDinh(false));
                diaChi.setDiaChiMacDinh(true);
            }
            diaChiService.update(diaChi);
        }
        return req;
    }

}
