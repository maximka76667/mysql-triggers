-- Insertar
UPDATE empleados
SET SalarioTotal = if(NEW.Salario is null, 0, NEW.Salario) + if(NEW.Comisionif is null, 0, NEW.Comisionif)
WHERE NUM_DEPARTAMENTO = NEW.NUM_DEPARTAMENTO;