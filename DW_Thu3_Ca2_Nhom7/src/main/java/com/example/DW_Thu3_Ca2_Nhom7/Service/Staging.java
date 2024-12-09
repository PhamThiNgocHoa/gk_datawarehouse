package com.example.DW_Thu3_Ca2_Nhom7.Service;

import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.DW_Thu3_Ca2_Nhom7.Enum.LocationDataBase;
import com.example.DW_Thu3_Ca2_Nhom7.MainDB.ConnectionInfoService;
import com.example.DW_Thu3_Ca2_Nhom7.MainDB.DynamicJdbiFactory;
import com.example.DW_Thu3_Ca2_Nhom7.Repository.ExtractDBInterface;
@Service
public class Staging {
	
	
	 private final ConnectionInfoService connectionInfoService;
	    private final DynamicJdbiFactory jdbiFactory;
	    private Jdbi jdbi;
	    @Autowired
	    ExtractDBInterface extractDBInterface;

	    public Staging(ConnectionInfoService connectionInfoService, DynamicJdbiFactory jdbiFactory) {
	        this.connectionInfoService = connectionInfoService;
	        this.jdbiFactory = jdbiFactory;
	        System.out.println(LocationDataBase.EXTRACT_DATA_DB.getUrl());
	        jdbi = connectionInfoService.createConnection(1, LocationDataBase.EXTRACT_DATA_DB.getUrl(), jdbiFactory);
	    };
	
	
	
	

	
	  

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
	    
	    
	    
	    public void updateProductDaily() {
	        jdbi.useHandle(handle -> {
	            handle.execute("CALL UpdateProductDaily()");
	        });
	    }

	    public void excute() {
	    
	        updataStatus();
	        insertProductDaily();

	        updateProductDaily();
	    

	    }
}
