package controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class UsersController {

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String text() {
		
		return "initialTest";
	}
	
	
}