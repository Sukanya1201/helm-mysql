package com.demo_k8s.crud.service;

import com.demo_k8s.crud.entity.Comment;
import com.demo_k8s.crud.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommentService {

    @Autowired
    private CommentRepository repository;

    public Comment addComment(Comment comment){
       return repository.save(comment);
    }

    public List<Comment> getComments(){
        return repository.findAll();
    }

    public Comment getCommentById(int id){
        return repository.findById(id)
                .orElseThrow(()->new IllegalArgumentException("Invalid id : "+id));
    }
}
