package com.sfwr.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * ViewController maps routes to JSP views.
 */
@Controller
public class ViewController {

	/** Home page. */
	@GetMapping({ "/", "/home" })
	public String home() {
		return "index";
	}

	/** Login page. */
	@GetMapping("/login")
	public String login() {
		return "login";
	}

	/** Registration page. */
	@GetMapping("/register")
	public String register() {
		return "register";
	}

	/** Dashboard page. */
	@GetMapping("/dashboard")
	public String dashboard() {
		return "dashboard";
	}

	/** Post food page. */
	@GetMapping("/postFood")
	public String postFood() {
		return "post-food";
	}

	/** Analytics page. */
	@GetMapping("/all-food")
	public String allFood() {
		return "all-food";
	}
	
	@GetMapping("/analytics")
	public String anylist() {
		return "analytics";
	}

	/** About page. */
	@GetMapping("/about")
	public String about() {
		return "about";
	}

	/** Contact Us page. */
	@GetMapping("/contact-us")
	public String contactUs() {
		return "contact-us";
	}
}
