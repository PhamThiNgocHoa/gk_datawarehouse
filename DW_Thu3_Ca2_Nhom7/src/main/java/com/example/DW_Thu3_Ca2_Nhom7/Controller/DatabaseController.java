package com.example.DW_Thu3_Ca2_Nhom7.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


import com.example.DW_Thu3_Ca2_Nhom7.Service.Extract;

@RestController
public class DatabaseController {
	@Autowired
    private  Extract extract;

  
    @GetMapping("/data")
    public List<String> getData(@RequestParam int dbName) {
    	
        return extract.getDataFromAnotherDB(dbName);
    }
    
    @GetMapping("/data1")
    public int getData1(@RequestParam String fileLocation,@RequestParam String tableName) {
        return extract.loadFile(fileLocation, tableName);
    }
    
    @GetMapping("/excute")
    public String excute(@RequestParam String fileLocation,@RequestParam String tableName) {
    	extract.excute(fileLocation, tableName);
    	return "thanh cong";
    }
}
