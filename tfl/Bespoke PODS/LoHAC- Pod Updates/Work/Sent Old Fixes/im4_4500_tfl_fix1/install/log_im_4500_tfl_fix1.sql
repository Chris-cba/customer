BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'im_4500_tfl_fix1.sql'
              ,p_remarks        => 'IM 4500 TFL FIX 1'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/