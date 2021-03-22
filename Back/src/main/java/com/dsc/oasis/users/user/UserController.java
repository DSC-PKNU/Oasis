package com.dsc.oasis.users.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(path = "api/oasis")
public class UserController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService){
        this.userService = userService;
    }

    @GetMapping("/test")
    public String test(){
        return "hello";
    }

    @PostMapping("/register")
    public String register(@RequestBody OasisUser user){
        return userService.register(user);
    }

    @PostMapping("/login")
    public String login(@RequestBody OasisUser user) throws Exception {
        return userService.login(user);
    }

    @GetMapping("/logout")
    public String logout(@RequestBody OasisUser user) throws Exception {
        return userService.logout(user);
    }

    @PostMapping("/insert-trashcan")
    public String insertTrashcan(@RequestBody OasisUser user) throws Exception{
        return userService.insertTrashcan(user);
    }
}
