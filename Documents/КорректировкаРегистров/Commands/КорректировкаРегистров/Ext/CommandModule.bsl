﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды) 

		ОткрытьФорму("Документ.КорректировкаРегистров.Форма.ФормаСписка",
			, // ПараметрыФормы,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно);


КонецПроцедуры

#КонецОбласти
