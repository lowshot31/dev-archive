// FILE START
// FILE PATH: src\main\java\com\sell_buy\sell_buy\db\repository\BoardRepository.java
package com.sell_buy.sell_buy.db.repository;

import com.sell_buy.sell_buy.db.entity.Board;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BoardRepository extends JpaRepository<Board, Long> {
    List<Board> findByTitleContaining(String title);
    List<Board> findByContentContaining(String content);
}
// FILE END