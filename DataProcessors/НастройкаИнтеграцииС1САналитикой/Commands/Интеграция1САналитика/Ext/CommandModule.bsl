﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Обработка.НастройкаИнтеграцииС1САналитикой.Форма.Форма",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.НастройкаИнтеграцииС1САналитикой.Форма.Форма" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти