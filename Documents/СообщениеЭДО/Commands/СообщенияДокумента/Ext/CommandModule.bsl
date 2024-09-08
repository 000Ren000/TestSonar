﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОтображатьЗаголовок", Ложь);
	ПараметрыФормы.Вставить("Отбор", Новый Структура);
	ПараметрыФормы.Отбор.Вставить("ЭлектронныйДокумент", ПараметрКоманды);
	ОткрытьФорму("Документ.СообщениеЭДО.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти