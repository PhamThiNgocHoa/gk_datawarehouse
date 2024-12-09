package com.example.DW_Thu3_Ca2_Nhom7.Service;


import org.jdbi.v3.core.Jdbi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.DW_Thu3_Ca2_Nhom7.Enum.LocationDataBase;
import com.example.DW_Thu3_Ca2_Nhom7.MainDB.ConnectionInfoService;
import com.example.DW_Thu3_Ca2_Nhom7.MainDB.DynamicJdbiFactory;
import com.example.DW_Thu3_Ca2_Nhom7.Repository.ExtractDBInterface;

@Service
public class LoadProduct {
    private final ConnectionInfoService connectionInfoService;
    private final DynamicJdbiFactory jdbiFactory;
    private Jdbi jdbi;
    @Autowired
    ExtractDBInterface extractDBInterface;
    public LoadProduct(ConnectionInfoService connectionInfoService, DynamicJdbiFactory jdbiFactory) {
        this.connectionInfoService = connectionInfoService;
        this.jdbiFactory = jdbiFactory;
        System.out.println(LocationDataBase.EXTRACT_DATA_DB.getUrl());
        jdbi = connectionInfoService.createConnection(1, LocationDataBase.EXTRACT_DATA_DB.getUrl(), jdbiFactory);
    };
    public int loadFile(){
        return extractDBInterface();
    }
    public  void excute(){
        int load =loadFile();
    }
}

