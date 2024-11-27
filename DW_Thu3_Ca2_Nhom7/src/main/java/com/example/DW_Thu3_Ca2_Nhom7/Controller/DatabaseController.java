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
    public List<String> getData(@RequestParam int dbName, @RequestParam String database) {
    	
        return extract.getDataFromAnotherDB(dbName,database);
    }
    
    @GetMapping("/data1")
    public int getData1(@RequestParam String fileLocation) {
        return extract.loadFile(fileLocation);
    }
    
    @GetMapping("/excute")
    public String excute(@RequestParam String fileLocation) {
    	extract.excute(fileLocation);
    	return "thanh cong";
    }
}
