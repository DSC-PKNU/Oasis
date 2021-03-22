package com.dsc.oasis.users.user;

import com.dsc.oasis.users.utils.Encrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class UserService {
    private final UserRepository userRepository;
    private final Encrypt encrypt;

    @Autowired
    public UserService(UserRepository userRepository, Encrypt encrypt){
        this.userRepository = userRepository;
        this.encrypt = encrypt;
    }

    public String register(OasisUser user) {
        String email = user.getEmail();
        String password = encrypt.hashPassword(user.getPassword());

        if(email.equals("") || password.equals("")){
            return "failed";
        }

        OasisUser realUser = new OasisUser();
        realUser.setEmail(email);
        realUser.setPassword(password);

        if(userRepository.findUserByEmail(email).isPresent()){
            throw new IllegalStateException("이미 유저가 존재합니다.");
        }

        userRepository.save(realUser);
        return "success";
    }

    public String login(OasisUser user) throws Exception {
        OasisUser reqUser = userRepository.findUserByEmail(user.getEmail())
                .orElseThrow(()->new IllegalStateException(
                        "user id" + user.getId()+"는 없습니다."
                ));

        boolean checkPassword = encrypt.comparePassword(user.getPassword(), reqUser.getPassword());
        if(!checkPassword){
            return "failed";
        }

        String token = encrypt.makeJwt(user.getId());
        reqUser.setToken(token);
        userRepository.save(reqUser);

        return "success";
    }

    public String logout(OasisUser user) throws Exception{
        OasisUser reqUser = userRepository.findUserByEmail(user.getEmail())
                .orElseThrow(()->new IllegalStateException(
                        "user id" + user.getId()+"는 없습니다."
                ));

        reqUser.setToken("");
        userRepository.save(reqUser);

        return "success";
    }

    public String insertTrashcan(OasisUser user) throws Exception{
        OasisUser reqUser = userRepository.findUserByEmail(user.getEmail())
                .orElseThrow(()->new IllegalStateException(
                        "user id" + user.getId()+"는 없습니다."
                ));

//        System.out.println(latitude);
//        System.out.println(reqUser.getToken().equals(""));

        if(reqUser.getToken().equals("")){
            return "로그인이 안된 사용자입니다.";
        }

        reqUser.setLat(user.getLat());
        reqUser.setLon(user.getLon());
        userRepository.save(reqUser);

        return "success";
    }
}
