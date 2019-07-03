package gov.ita.terrafreights.tariff;

import gov.ita.terrafreights.tariff.stagingbasket.StagingBasket;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TariffRepository extends JpaRepository<Tariff, Long> {
  List<Tariff> findByCountryCode(String countryCode);

  Page<Tariff> findByCountryCode(String countryCode, Pageable pageable);

  Page<Tariff> findByCountryCodeAndStagingBasketId(String countryCode, Long stagingBasketId, Pageable pageable);

  Page<Tariff> findByCountryCodeAndStagingBasketIdAndTariffLineContaining(String countryCode, Long stagingBasketId, String tariffLine, Pageable pageable);

  Page<Tariff> findByCountryCodeAndTariffLineContaining(String countryCode, String tariffLine, Pageable pageable);

  @Query(value = "select distinct new StagingBasket(s.id, s.description) " +
    "from Tariff t " +
    "join StagingBasket s on t.stagingBasket.id = s.id " +
    "join Country c on t.country.id = c.id " +
    "where c.code = ?1")
  List<StagingBasket> findAllStagingBasketsByCountry(String countryCode);

  @Query(value = "SELECT new gov.ita.terrafreights.tariff.TariffCount(c.code, COUNT(t) as total) " +
    "FROM Tariff t join Country c on t.country.id = c.id  GROUP BY c.id")
  List<TariffCount> tariffCountsByCountry();
}
