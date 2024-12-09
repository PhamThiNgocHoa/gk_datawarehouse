package com.example.DW_Thu3_Ca2_Nhom7.Service;


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


}
