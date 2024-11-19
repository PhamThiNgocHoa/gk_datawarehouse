package com.example.DW_Thu3_Ca2_Nhom7.Service;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.StatementContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
    public Extract(ConnectionInfoService connectionInfoService, DynamicJdbiFactory jdbiFactory) {
        this.connectionInfoService = connectionInfoService;
        this.jdbiFactory = jdbiFactory;
        jdbi = createConnection(1);
    }

    
    
    private Jdbi createConnection(int dbName) {
      
        Optional<Map<String, String>> connectionInfoOpt = connectionInfoService.getConnectionInfo(dbName);

       
        if (connectionInfoOpt.isEmpty()) {
            throw new RuntimeException("Không thể tìm thấy thông tin kết nối cho dbName: " + dbName);
        }

        // Lấy thông tin kết nối
        Map<String, String> connectionInfo = connectionInfoOpt.get();
        System.out.println(connectionInfo);
     
        return jdbiFactory.createJdbi(
                connectionInfo.get("url"),
                connectionInfo.get("username"),
                connectionInfo.get("password")
        );
    }
    
    public List<String> getDataFromAnotherDB(int dbName) {
        
        Optional<Map<String, String>> connectionInfoOpt = connectionInfoService.getConnectionInfo(dbName);

        // Kiểm tra nếu thông tin kết nối không có
        if (connectionInfoOpt.isEmpty()) {
            throw new RuntimeException("Không thể tìm thấy thông tin kết nối cho dbName: " + dbName);
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

    public int loadFile(String fileLocation, String tableName) {
        return extractDBInterface.loadFileToTable(fileLocation);
    }

    public void updataStatus() {
    	
        jdbi.useHandle(handle ->{
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
    
    public void excute(String fileLocation, String tableName) {
    int load =	loadFile(fileLocation, tableName);
    	updataStatus();
    	insertProductDaily();
    }
}