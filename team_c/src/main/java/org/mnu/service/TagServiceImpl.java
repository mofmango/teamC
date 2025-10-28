package org.mnu.service;

import java.util.List;
import org.mnu.mapper.TagMapper;
import org.springframework.stereotype.Service;
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class TagServiceImpl implements TagService {

    private TagMapper mapper;

    @Override
    public List<String> getTagsByBno(Long bno) {
        return mapper.getTagsByBno(bno);
    }
}