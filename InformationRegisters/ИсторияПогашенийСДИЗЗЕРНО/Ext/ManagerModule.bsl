﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаЗагрузкиПолученныхДанных(ЭлементОчереди, ПараметрыОбмена, ПолученныеДанные, ИзмененныеОбъекты) Экспорт
	
	Операция         = ЭлементОчереди.Операция;
	ПараметрыЗапроса = ЭлементОчереди.РеквизитыИсходящегоСообщения.ПараметрыЗапроса;
	
	Если Операция = Перечисления.ВидыОперацийЗЕРНО.ЗапросПогашенийСДИЗ Тогда
		
		ДанныеДляОбработки = ИнтеграцияЗЕРНОСлужебный.МассивДанныхПоляXDTO(ПолученныеДанные.Record);
		
		Блокировка = Новый БлокировкаДанных();
		
		ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.СДИЗЗЕРНО.ПолноеИмя());
		ЭлементБлокировки.УстановитьЗначение("Идентификатор", ПараметрыЗапроса.НомерСДИЗ);
		
		Попытка
			
			Блокировка.Заблокировать();
			СДИЗ = Справочники.СДИЗЗЕРНО.СДИЗ(
				ПараметрыЗапроса.НомерСДИЗ,
				ЭлементОчереди.Организация,
				ЭлементОчереди.Подразделение,
				ЭлементОчереди.ВидПродукции, ПараметрыОбмена);
			
			БлокировкаРегистраИстории = Новый БлокировкаДанных();
			ЭлементБлокировки = БлокировкаРегистраИстории.Добавить(Метаданные.РегистрыСведений.ИсторияПогашенийСДИЗЗЕРНО.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("СДИЗ", СДИЗ);
			Блокировка.Заблокировать();
			УстановитьПривилегированныйРежим(Истина);
			
			ОперацияИстории    = Перечисления.ВидыОперацийЗЕРНО.ПогашениеСДИЗ;
			НаборДанных        = НаборДанныхИсторияПогашенийСДИЗДляОперации(СДИЗ, ОперацияИстории);
			ИмяПоляНомерПартии = ИмяПоляНомерПартии(ЭлементОчереди.ВидПродукции);
			
			Для Каждого ЭлементДанных Из ДанныеДляОбработки Цикл
				
				НоваяСтрока = НаборДанных.Добавить();
				НоваяСтрока.СДИЗ                = СДИЗ;
				НоваяСтрока.НомерПартии         = ЭлементДанных[ИмяПоляНомерПартии];
				НоваяСтрока.КоличествоЗЕРНО     = ЭлементДанных.amount;
				НоваяСтрока.ОписаниеПричины     = ЭлементДанных.CauseComment;
				НоваяСтрока.ВидОперации         = ОперацияИстории;
				НоваяСтрока.ИдентификаторЗаявки = Формат(ЭлементДанных.id, "ЧГ=0;");
				НоваяСтрока.ПолноеПогашение     = ЭлементДанных.fullExtinction;
				НоваяСтрока.ДатаОперации        = ЭлементДанных.dateRegistration;
				Если ЭлементДанных.WeightDiscrepancyCause <> Неопределено Тогда
					НоваяСтрока.Причина = Справочники.КлассификаторНСИЗЕРНО.КлассификаторНСИ(
						Перечисления.ВидыКлассификаторовЗЕРНО.ПричинаРасхожденияВеса,
						ЭлементДанных.WeightDiscrepancyCause,
						ЭлементОчереди.Организация,
						ЭлементОчереди.Подразделение,,
						ПараметрыОбмена);
				КонецЕсли;
				НоваяСтрока.Статус = ИнтеграцияЗЕРНОСлужебный.СтатусЗаписи(ЭлементДанных.status);
				
			КонецЦикла;
			
			Если ДанныеДляОбработки.Количество() Тогда
				ИзмененныеОбъекты.Добавить(СДИЗ);
			КонецЕсли;
			
			НаборДанных.Записать();
			
		Исключение
			ВызватьИсключение;
		КонецПопытки;
		
	ИначеЕсли Операция = Перечисления.ВидыОперацийЗЕРНО.ЗапросОтказовПогашенийСДИЗ Тогда
		
		ДанныеДляОбработки = ИнтеграцияЗЕРНОСлужебный.МассивДанныхПоляXDTO(ПолученныеДанные.Record);
		
		Блокировка = Новый БлокировкаДанных();
		
		ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.СДИЗЗЕРНО.ПолноеИмя());
		ЭлементБлокировки.УстановитьЗначение("Идентификатор", ПараметрыЗапроса.НомерСДИЗ);
		
		Попытка
			
			Блокировка.Заблокировать();
			СДИЗ = Справочники.СДИЗЗЕРНО.СДИЗ(
				ПараметрыЗапроса.НомерСДИЗ,
				ЭлементОчереди.Организация,
				ЭлементОчереди.Подразделение,
				ЭлементОчереди.ВидПродукции,
				ПараметрыОбмена);
			
			БлокировкаРегистраИстории = Новый БлокировкаДанных();
			ЭлементБлокировки = БлокировкаРегистраИстории.Добавить(Метаданные.РегистрыСведений.ИсторияПогашенийСДИЗЗЕРНО.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("СДИЗ", СДИЗ);
			Блокировка.Заблокировать();
			
			УстановитьПривилегированныйРежим(Истина);
			
			ОперацияИстории    = Перечисления.ВидыОперацийЗЕРНО.ОформлениеСДИЗОтказПогашенияСДИЗ;
			НаборДанных        = НаборДанныхИсторияПогашенийСДИЗДляОперации(СДИЗ, ОперацияИстории);
			ИмяПоляНомерПартии = ИмяПоляНомерПартии(ЭлементОчереди.ВидПродукции);
			ИмяПоляПричина     = ИмяПоляПричина(ЭлементОчереди.ВидПродукции);
			
			Для Каждого ЭлементДанных Из ДанныеДляОбработки Цикл
				
				НоваяСтрока = НаборДанных.Добавить();
				НоваяСтрока.СДИЗ                = СДИЗ;
				НоваяСтрока.НомерПартии         = ЭлементДанных[ИмяПоляНомерПартии];
				НоваяСтрока.КоличествоЗЕРНО     = ЭлементДанных.amount;
				НоваяСтрока.ОписаниеПричины     = ЭлементДанных.CauseComment;
				НоваяСтрока.ВидОперации         = ОперацияИстории;
				НоваяСтрока.ИдентификаторЗаявки = Формат(ЭлементДанных.id, "ЧГ=0;");
				НоваяСтрока.ДатаОперации        = ЭлементДанных.dateRegistration;
				Если ЭлементДанных[ИмяПоляПричина] <> Неопределено Тогда
					НоваяСтрока.Причина = Справочники.КлассификаторНСИЗЕРНО.КлассификаторНСИ(
						Перечисления.ВидыКлассификаторовЗЕРНО.ПричинаВозвратаПартии,
						ЭлементДанных[ИмяПоляПричина],
						ЭлементОчереди.Организация,
						ЭлементОчереди.Подразделение,
						ПараметрыОбмена);
				КонецЕсли;
				НоваяСтрока.Статус = ИнтеграцияЗЕРНОСлужебный.СтатусЗаписи(ЭлементДанных.status);
				
			КонецЦикла;
			
			Если ДанныеДляОбработки.Количество() Тогда
				ИзмененныеОбъекты.Добавить(СДИЗ);
			КонецЕсли;
			
			НаборДанных.Записать();
			
		Исключение
			ВызватьИсключение;
		КонецПопытки;
	
	КонецЕсли;
	
КонецПроцедуры

Функция ИмяПоляНомерПартии(ВидПродукции)
	
	Если ВидПродукции = Перечисления.ВидыПродукцииИС.Зерно Тогда
		Возврат "createLotNumber";
	Иначе
		Возврат "createGpbNumber";
	КонецЕсли;
	
КонецФункции

Функция ИмяПоляПричина(ВидПродукции)
	
	Если ВидПродукции = Перечисления.ВидыПродукцииИС.Зерно Тогда
		Возврат "LotReturnReasonCode";
	Иначе
		Возврат "GpbReturnReasonCode";
	КонецЕсли;
	
КонецФункции

Функция НаборДанныхИсторияПогашенийСДИЗДляОперации(СДИЗ, Операция)
	
	НаборДанных = СоздатьНаборЗаписей();
	НаборДанных.Отбор.СДИЗ.Установить(СДИЗ);
	НаборДанных.Прочитать();
	
	ТекущиеДанные = НаборДанных.Выгрузить();
	
	НаборДанных.Очистить();
	
	Для Каждого СтрокаТаблицы Из ТекущиеДанные Цикл
		Если СтрокаТаблицы.ВидОперации = Операция Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = НаборДанных.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
	КонецЦикла;
	
	Возврат НаборДанных;
	
КонецФункции

Функция СтруктураОбновленияЗаписи() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	
	Для Каждого Ресурс Из Метаданные.РегистрыСведений.ИсторияПогашенийСДИЗЗЕРНО.Ресурсы Цикл
		ВозвращаемоеЗначение.Вставить(Ресурс.Имя);
	КонецЦикла;
	
	Для Каждого Реквизит Из Метаданные.РегистрыСведений.ИсторияПогашенийСДИЗЗЕРНО.Реквизиты Цикл
		ВозвращаемоеЗначение.Вставить(Реквизит.Имя);
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Процедура ОбновитьЗаписьРегистра(СДИЗ, НомерПартии, ПараметрыОбновления, НоваяЗапись = Ложь) Экспорт
	
	МенеджерЗаписи = СоздатьМенеджерЗаписи();
	МенеджерЗаписи.СДИЗ        = СДИЗ;
	МенеджерЗаписи.НомерПартии = НомерПартии;
	
	Если Не НоваяЗапись Тогда
		МенеджерЗаписи.Прочитать();
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из ПараметрыОбновления Цикл
		Если КлючИЗначение.Значение = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		МенеджерЗаписи[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
	КонецЦикла;
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
