package com.example.DW_Thu3_Ca2_Nhom7.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.DW_Thu3_Ca2_Nhom7.DTO.CategorySalesSummaryDTO;
import com.example.DW_Thu3_Ca2_Nhom7.Enum.LocationDataBase;
import com.example.DW_Thu3_Ca2_Nhom7.MainDB.ConnectionInfoService;
import com.example.DW_Thu3_Ca2_Nhom7.MainDB.DynamicJdbiFactory;
import com.example.DW_Thu3_Ca2_Nhom7.Repository.ExtractDBInterface;

@Service
public class Extract {

    private final ConnectionInfoService connectionInfoService;
    private final DynamicJdbiFactory jdbiFactory;
    private Jdbi jdbi;
    @Autowired
    ExtractDBInterface extractDBInterface;
    
    @Autowired
    LoadProduct loadProduct;
    @Autowired
    Staging staging;
    @Autowired
    Datamart datamart;
    @Autowired
    Datawarehouse datawarehouse;

    public Extract(ConnectionInfoService connectionInfoService, DynamicJdbiFactory jdbiFactory) {
        this.connectionInfoService = connectionInfoService;
        this.jdbiFactory = jdbiFactory;
        System.out.println(LocationDataBase.EXTRACT_DATA_DB.getUrl());
        jdbi = createConnection(1, LocationDataBase.EXTRACT_DATA_DB.getUrl());
    }


    public Jdbi createConnection(int file_id, String database) {

        Optional<Map<String, String>> connectionInfoOpt = connectionInfoService.getConnectionInfo(file_id, database);


        if (connectionInfoOpt.isEmpty()) {
            throw new RuntimeException("Không thể tìm thấy thông tin kết nối cho dbName: " + database);
        }

       
        Map<String, String> connectionInfo = connectionInfoOpt.get();
        System.out.println(connectionInfo);

        return jdbiFactory.createJdbi(
                connectionInfo.get("url"),
                connectionInfo.get("username"),
                connectionInfo.get("password")
        );
    }

    public List<String> getDataFromAnotherDB(int file_id, String database) {

        Optional<Map<String, String>> connectionInfoOpt = connectionInfoService.getConnectionInfo(file_id, database);

        // Kiểm tra nếu thông tin kết nối không có
        if (connectionInfoOpt.isEmpty()) {
            throw new RuntimeException("Không thể tìm thấy thông tin kết nối cho dbName: " + database);
        }

        // Lấy thông tin kết nối
        Map<String, String> connectionInfo = connectionInfoOpt.get();

        // Tạo Jdbi cho database cụ thể
        jdbi = jdbiFactory.createJdbi(
                connectionInfo.get("url"),
                connectionInfo.get("username"),
                connectionInfo.get("password")
        );

        // Khởi tạo danh sách kết quả
        List<String> resultList = new ArrayList<>();

        // Sử dụng JDBI để thực thi thủ tục và ánh xạ kết quả
        jdbi.useHandle(handle -> {
            // Gọi thủ tục lưu trữ
            handle.execute("CALL GetAllProducts()");

            // Truy vấn và ánh xạ kết quả
            resultList.addAll(
                    handle.createQuery("SELECT name FROM control_db.temp_product_daily")
                            .mapTo(String.class) // Ánh xạ cột "name" thành String
                            .list()
            );
        });

        return resultList;
    }

    public int loadFile() {
        return extractDBInterface.loadFileToTable();
    }

    public void updataStatus() {

        jdbi.useHandle(handle -> {
            handle.execute("CALL UpdateDuplicateStatus()");
        });
    }


    public void insertProductDaily() {
        try (Handle handle = jdbi.open()) {
            handle.useTransaction(transaction -> {

                int affectedRows = transaction.execute("CALL InsertProductDaily()");
                System.out.println("Rows affected: " + affectedRows);


                if (affectedRows > 0) {
                    String logInsertQuery = """
                                INSERT INTO control_db.logs (file_id, process_step, status, log_message)
                                VALUES (:fileId, :processStep, :status, :logMessage)
                            """;

                    transaction.createUpdate(logInsertQuery)
                            .bind("fileId", 1) // ID của file
                            .bind("processStep", "Extract")
                            .bind("status", "Success")
                            .bind("logMessage", "Extract thanh cong. Du lieu da tai vao Staging")
                            .execute();

                    System.out.println("Log entry created successfully.");
                }
            });
        } catch (Exception e) {

            System.out.println("Procedure execution failed: " + e.getMessage());


            try (Handle handle = jdbi.open()) {
                String logErrorQuery = """
                            INSERT INTO control_db.logs (file_id, process_step, status, log_message)
                            VALUES (:fileId, :processStep, :status, :logMessage)
                        """;

                handle.createUpdate(logErrorQuery)
                        .bind("fileId", 1)
                        .bind("processStep", "InsertProductDaily")
                        .bind("status", "Failure")
                        .bind("logMessage", e.getMessage())
                        .execute();

                System.out.println("Error log entry created successfully.");
            } catch (Exception logEx) {
                System.out.println("Failed to create error log entry: " + logEx.getMessage());
            }
        }

    }


        public void loadDatedim() {
        extractDBInterface.loadDateDim();
    }
    public void updateProductDaily() {
        jdbi.useHandle(handle -> {
            handle.execute("CALL UpdateProductDaily()");
        });
    }

    public void insertProductInfo() {
        jdbi.useHandle(handle -> {
            handle.execute("CALL insertProductInfo()");
        });
    }


    public void insertSellerInfo() {

        jdbi.useHandle(handle -> {
            handle.execute("CALL insertSellerInfo()");
        });
    }


    public void insertBrandInfo() {

        jdbi.useHandle(handle -> {
            handle.execute("CALL insertBrandInfo()");
        });
    }

    public void insertProductPriceHistory() {

        jdbi.useHandle(handle -> {
            handle.execute("CALL insertProductPriceHistory()");
        });
    }

    public void insertProductRating() {

        jdbi.useHandle(handle -> {
            handle.execute("CALL insertProductRating()");
        });
    }


    public void insertSalesSummary() {
        jdbi.useHandle(handle -> {
            handle.execute("CALL insertSalesSummary()");
        });
    }

    public void insertBrandPerformance() {
        jdbi.useHandle(handle -> {
            handle.execute("CALL insertBrandPerformance()");
        });
    }

    public void insertCategorySaleSummary() {
        jdbi.useHandle(handle -> {
            handle.execute("CALL insertCategorySaleSummary()");
        });
    }

    public void updataStatusDatamart() {

        jdbi.useHandle(handle -> {
            handle.execute("CALL UpdateDuplicateStatus()");
        });
    }
    
    
    
    public  List<CategorySalesSummaryDTO> getCategorySalesSummary() {
        // Sử dụng jdbi để gọi thủ tục và lấy dữ liệu
        return jdbi.withHandle(handle -> {
            // Gọi thủ tục và ánh xạ kết quả trả về thành các đối tượng CategorySalesSummaryDTO
            return handle.createQuery("CALL selectCategorySaleSummary()")
                    .mapToBean(CategorySalesSummaryDTO.class)  // Ánh xạ vào DTO
                    .list();  // Trả về danh sách kết quả
        });
    }

    public void excute() {
//        int load = loadFile();
//        updataStatus();
//        insertProductDaily();
////        loadDatedim();
//        updateProductDaily();
//        insertProductInfo();
//        insertSellerInfo();
//        insertBrandInfo();
//        insertProductPriceHistory();
//        insertProductRating();
//        insertSalesSummary();
//        insertBrandPerformance();
//        insertCategorySaleSummary();
        
        
//        loadProduct.excute();
//        staging.excute();
//        datawarehouse.excute();
//        datamart.excute();

    }
}
