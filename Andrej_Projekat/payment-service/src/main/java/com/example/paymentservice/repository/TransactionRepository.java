package com.example.paymentservice.repository;

import com.example.paymentservice.dto.RevenuePeriodProjection;
import com.example.paymentservice.dto.VipCustomerProjection;
import com.example.paymentservice.model.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface TransactionRepository extends JpaRepository<Transaction, Long> {

    @Query("SELECT t FROM Transaction t LEFT JOIN FETCH t.paymentItems WHERE t.orderId = :orderId")
    Optional<Transaction> findByOrderId(@Param("orderId") Long orderId);

    @Query("SELECT t FROM Transaction t LEFT JOIN FETCH t.paymentItems WHERE t.userId = :userId")
    List<Transaction> findByUserId(@Param("userId") Long userId);

    @Modifying
    @Query("UPDATE Transaction t SET t.card = NULL WHERE t.card.id = :cardId")
    void nullifyCard(@Param("cardId") Long cardId);

    @Query(value = """
            SELECT to_char(paid_at, 'YYYY-MM-DD') AS "period",
                   SUM(amount)                    AS "revenue",
                   COUNT(*)                       AS "transactionCount"
            FROM transactions
            GROUP BY to_char(paid_at, 'YYYY-MM-DD')
            ORDER BY "period" DESC
            LIMIT 30
            """, nativeQuery = true)
    List<RevenuePeriodProjection> getRevenueByDay();

    @Query(value = """
            SELECT to_char(paid_at, 'IYYY"-W"IW') AS "period",
                   SUM(amount)                    AS "revenue",
                   COUNT(*)                       AS "transactionCount"
            FROM transactions
            GROUP BY to_char(paid_at, 'IYYY"-W"IW')
            ORDER BY "period" DESC
            LIMIT 12
            """, nativeQuery = true)
    List<RevenuePeriodProjection> getRevenueByWeek();

    @Query(value = """
            SELECT to_char(paid_at, 'YYYY-MM') AS "period",
                   SUM(amount)                 AS "revenue",
                   COUNT(*)                    AS "transactionCount"
            FROM transactions
            GROUP BY to_char(paid_at, 'YYYY-MM')
            ORDER BY "period" DESC
            LIMIT 12
            """, nativeQuery = true)
    List<RevenuePeriodProjection> getRevenueByMonth();

    @Query(value = """
            SELECT u.id   AS "userId",
                   u.name AS "userName",
                   SUM(t.amount) AS "totalSpent",
                   COUNT(t.id)   AS "ordersCount"
            FROM users u
            JOIN transactions t ON t.user_id = u.id
            GROUP BY u.id, u.name
            ORDER BY "totalSpent" DESC
            LIMIT 10
            """, nativeQuery = true)
    List<VipCustomerProjection> getVipCustomers();
}
