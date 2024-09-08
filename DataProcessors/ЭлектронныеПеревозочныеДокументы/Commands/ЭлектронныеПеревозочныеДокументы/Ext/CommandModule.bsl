﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("КлючНазначенияФормы", "ФормаСпискаЭПД");
	
	ОценкаПроизводительностиКлиент.ЗамерВремени(
								"Обработка.ЭлектронныеПеревозочныеДокументы.Команда.ЭлектронныеПеревозочныеДокументы");
	
	ОткрытьФорму("Обработка.ЭлектронныеПеревозочныеДокументы.Форма.ФормаСпискаЭПД", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти