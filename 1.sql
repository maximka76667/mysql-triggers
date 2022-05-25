-- Insertar
CREATE DEFINER=`root`@`localhost` TRIGGER `empresa`.`empleados_AFTER_INSERT` AFTER INSERT ON `empleados` FOR EACH ROW
BEGIN
  UPDATE departamentos
  SET NumEmpleados = NumEmpleados + 1,
  SumaSalarios = SumaSalarios + if(NEW.Salario is null, 0, NEW.Salario),
  MediaSalarios = SumaSalarios / NumEmpleados
  WHERE NUM_DEPARTAMENTO = NEW.NUM_DEPARTAMENTO;
END

-- Update
CREATE DEFINER=`root`@`localhost` TRIGGER `empresa`.`empleados_AFTER_UPDATE` AFTER UPDATE ON `empleados` FOR EACH ROW
BEGIN
  UPDATE departamentos
  SET NumEmpleados = NumEmpleados + IF(NEW.NUM_DEPARTAMENTO <> OLD.NUM_DEPARTAMENTO, 1, 0),
  SumaSalarios = IF(SumaSalarios is null, 0, SumaSalarios) + if(NEW.Salario is null, 0, NEW.SALARIO),
  MediaSalarios = SumaSalarios / IF(NumEmpleados = 0, 1, NumEmpleados)
  WHERE NUM_DEPARTAMENTO = NEW.NUM_DEPARTAMENTO;

  UPDATE departamentos
  SET NumEmpleados = NumEmpleados - IF(NEW.NUM_DEPARTAMENTO <> OLD.NUM_DEPARTAMENTO, 1, 0),
  SumaSalarios = SumaSalarios - OLD.SALARIO, 
  MediaSalarios = SumaSalarios / IF(NumEmpleados = 0, 1, NumEmpleados)
  WHERE NUM_DEPARTAMENTO = OLD.NUM_DEPARTAMENTO;
END

-- Borrar
CREATE DEFINER=`root`@`localhost` TRIGGER `empresa`.`empleados_AFTER_DELETE` AFTER DELETE ON `empleados` FOR EACH ROW
BEGIN
  UPDATE departamentos
  SET NumEmpleados = NumEmpleados - 1,
  SumaSalarios = SumaSalarios - OLD.salario,
  MediaSalarios = SumaSalarios / IF(NumEmpleados = 0, 1, NumEmpleados)
  WHERE NUM_DEPARTAMENTO = OLD.NUM_DEPARTAMENTO;
END