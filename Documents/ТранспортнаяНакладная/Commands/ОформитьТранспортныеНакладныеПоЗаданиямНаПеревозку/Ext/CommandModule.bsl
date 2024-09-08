﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОчиститьСообщения();	
		
	СозданныеТранспортныеНакладные = СоздатьТранспортныеНакладныеНаСервере(ПараметрКоманды);
						
	Если СозданныеТранспортныеНакладные.Количество() = 1 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", СозданныеТранспортныеНакладные[0]);
		
		ОткрытьФорму(
				"Документ.ТранспортнаяНакладная.ФормаОбъекта", 
				ПараметрыФормы);
				
	ИначеЕсли СозданныеТранспортныеНакладные.Количество() > 1 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТранспортныеНакладные", СозданныеТранспортныеНакладные);
		
		ОткрытьФорму(
				"Документ.ТранспортнаяНакладная.Форма.СозданныеТранспортныеНакладные", 
				ПараметрыФормы);
				
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СоздатьТранспортныеНакладныеНаСервере(ВыделенныеСсылки)
	
	РезультатПроверки = Документы.ТранспортнаяНакладная.ПроверитьДокументыОснования(ВыделенныеСсылки);
	
	ШаблонОшибкиТНСозданы = НСтр("ru='Для документа ""%Документ%"" не требуется оформлять транспортные накладные, т.к. они уже оформлены или в задании на перевозку нет ни одного маршрута.'");
	
	Для Каждого СтрМас из РезультатПроверки.ЗаданияНаПеревозкуПоКоторымНакладныеУжеСозданы Цикл
	
		ТекстСообщения = СтрЗаменить(ШаблонОшибкиТНСозданы, "%Документ%", СтрМас);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, СтрМас);
		
	КонецЦикла;
	
	СозданныеТранспортныеНакладные = Документы.ТранспортнаяНакладная.СоздатьТранспортныеНакладные(
												РезультатПроверки.ЗаданияНаПеревозкуДляСозданияТранспортныхНакладных
												,,,
												РезультатПроверки.ОбъектыПоКоторымНакладныеУжеСозданы);
	
	Возврат СозданныеТранспортныеНакладные;
	
КонецФункции

#КонецОбласти