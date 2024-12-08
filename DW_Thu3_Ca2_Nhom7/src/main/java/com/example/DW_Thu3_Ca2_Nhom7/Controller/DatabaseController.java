package com.example.DW_Thu3_Ca2_Nhom7.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.example.DW_Thu3_Ca2_Nhom7.DTO.CategorySalesSummaryDTO;
import com.example.DW_Thu3_Ca2_Nhom7.Service.Extract;
import com.fasterxml.jackson.databind.ObjectMapper;

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
        return extract.loadFile();
    }
    
    @GetMapping("/excute")
    public String excute() {
    	extract.excute();
    	return "thanh cong";
    }
    
    
	/*
	 * @GetMapping("/index") public ModelAndView index() { ModelAndView modelAndView
	 * = new ModelAndView("index"); return modelAndView; }
	 */
    
    
    @GetMapping("/categorySaleSummary")
    public ModelAndView showCategorySaleSummary() {
        ModelAndView modelAndView = new ModelAndView("index");
        List<CategorySalesSummaryDTO> salesSummaryList = extract.getCategorySalesSummary();
        
        // Chuyển danh sách sang JSON
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            String salesSummaryJson = objectMapper.writeValueAsString(salesSummaryList);
            modelAndView.addObject("salesSummaryJson", salesSummaryJson);
        } catch (Exception e) {
            e.printStackTrace();
            modelAndView.addObject("salesSummaryJson", "[]"); // Trường hợp lỗi, gửi mảng rỗng
        }
        
        return modelAndView;
    }
}
