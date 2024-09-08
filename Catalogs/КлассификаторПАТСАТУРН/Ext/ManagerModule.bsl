﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает текст запроса получения информации о сопоставлении ПАТ
//   номенклатуре, производителям, маркировке.
//
// Возвращаемое значение:
//   Строка - текст запроса
//
Функция ТекстЗапросаИнформацияОСопоставлении() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СоответствиеНоменклатурыСАТУРН.ПАТ КАК ПАТ,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СоответствиеНоменклатурыСАТУРН.Номенклатура) КАК Количество
	|ПОМЕСТИТЬ СопоставленоПозиций
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыСАТУРН КАК СоответствиеНоменклатурыСАТУРН
	|ГДЕ
	|	СоответствиеНоменклатурыСАТУРН.ПАТ В (&ПАТ)
	|СГРУППИРОВАТЬ ПО
	|	СоответствиеНоменклатурыСАТУРН.ПАТ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПАТ
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Товары.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(СопоставленоПозиций.Количество, 0) КАК Количество,
	|	СоответствиеНоменклатурыСАТУРН.Номенклатура КАК Номенклатура,
	|	СоответствиеНоменклатурыСАТУРН.Характеристика КАК Характеристика,
	|	ПРЕДСТАВЛЕНИЕ(СоответствиеНоменклатурыСАТУРН.Номенклатура) КАК НоменклатураПредставление
	|ИЗ
	|	Справочник.КлассификаторПАТСАТУРН КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленоПозиций КАК СопоставленоПозиций
	|		ПО (СопоставленоПозиций.ПАТ = Товары.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыСАТУРН КАК СоответствиеНоменклатурыСАТУРН
	|		ПО Товары.Ссылка = СоответствиеНоменклатурыСАТУРН.ПАТ
	|		И (СопоставленоПозиций.Количество = 1
	|		ИЛИ СоответствиеНоменклатурыСАТУРН.Порядок = 1)
	|ГДЕ
	|	Товары.Ссылка В (&ПАТ)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Тогда
	
		Если Параметры = Неопределено Тогда
			Параметры = Новый Структура();
		КонецЕсли;
		
		Параметры.Вставить("РежимВыбора", Истина);
		
		ВыбраннаяФорма       = "Справочник.КлассификаторПАТСАТУРН.Форма.ФормаСписка";
		СтандартнаяОбработка = Ложь;
	
	КонецЕсли;

КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Обмен

Функция ДанныеОбъекта(ЭлементДанных) Экспорт
	
	ДанныеПАТ = Новый Структура();
	
	ДанныеПАТ.Вставить("GUID",                            ЭлементДанных.sys_guid);
	ДанныеПАТ.Вставить("Идентификатор",                   ЭлементДанных.id);
	ДанныеПАТ.Вставить("Статус",                          ИнтерфейсСАТУРН.Статус(ЭлементДанных.lcState));
	ДанныеПАТ.Вставить("ДатаСоздания",                    ОбщегоНазначенияИСКлиентСервер.ДатаИзСтрокиUNIX(ЭлементДанных.sys_timeFrom));
	ДанныеПАТ.Вставить("ДатаИзменения",                   ОбщегоНазначенияИСКлиентСервер.ДатаИзСтрокиUNIX(ЭлементДанных.sys_changedAt));
	ДанныеПАТ.Вставить("Наименование",                    ЭлементДанных.name);
	ДанныеПАТ.Вставить("ОКПД2",                           ЭлементДанных.okpd);
	ДанныеПАТ.Вставить("ВидПродукции",                    ИнтерфейсСАТУРН.ВидПродукции(ЭлементДанных.type));
	ДанныеПАТ.Вставить("Комментарий",                     ЭлементДанных.description);
	ДанныеПАТ.Вставить("СодержаниеДействующегоВещества",  ЭлементДанных.amount);
	ДанныеПАТ.Вставить("НомерГосударственнойРегистрации", ЭлементДанных.numGosReg);
	
	// инициализация значений, которые могут отсутствовать в структуре данных
	ДанныеПАТ.Вставить("ДатаРегистрации",                 "");
	ДанныеПАТ.Вставить("ДатаОкончанияРегистрации",        "");
	ДанныеПАТ.Вставить("РН",                              "");
	ДанныеПАТ.Вставить("Препарат",                        "");
	ДанныеПАТ.Вставить("Разрешения",                      "");
	ДанныеПАТ.Вставить("Группа",                          "");
	ДанныеПАТ.Вставить("Регистрант",                      "");
	ДанныеПАТ.Вставить("ДействующееВещество",             "");
	ДанныеПАТ.Вставить("ПрепаративнаяФорма",              "");
	ДанныеПАТ.Вставить("КлассОпасности",                  "");
	ДанныеПАТ.Вставить("ДанныеПроизводителя",             Неопределено);
	ДанныеПАТ.Вставить("ИдентификаторПроизводителя",      "");
	ДанныеПАТ.Вставить("СоставТукосмеси",                 Новый Массив);
	
	Если ЭлементДанных.Свойство("dateFrom") Тогда
		ДанныеПАТ.Вставить("ДатаРегистрации",          ИнтерфейсСАТУРН.ДатаИзСтрокиISO(ЭлементДанных.dateFrom));
	КонецЕсли;
	
	Если ЭлементДанных.Свойство("dateTo") Тогда
		ДанныеПАТ.Вставить("ДатаОкончанияРегистрации", ИнтерфейсСАТУРН.ДатаИзСтрокиISO(ЭлементДанных.dateTo));
	КонецЕсли;

	Если ЭлементДанных.Свойство("rn") Тогда
		ДанныеПАТ.Вставить("РН",         ЭлементДанных.rn);
	КонецЕсли;
	
	Если ЭлементДанных.Свойство("preparat") Тогда
		ДанныеПАТ.Вставить("Препарат",   ЭлементДанных.preparat);
	КонецЕсли;
	
	Если ЭлементДанных.Свойство("razresheniya") Тогда
		ДанныеПАТ.Вставить("Разрешения", ЭлементДанных.razresheniya);
	КонецЕсли;
	
	Если ЭлементДанных.Свойство("group") Тогда
		ДанныеПАТ.Вставить("Группа",     ЭлементДанных.group);
	КонецЕсли;
	
	Если ЭлементДанных.Свойство("registrant") Тогда
		ДанныеПАТ.Вставить("Регистрант", ЭлементДанных.registrant);
	КонецЕсли;
	
	Если ЭлементДанных.Свойство("activeSubstance") Тогда
		ДанныеПАТ.Вставить("ДействующееВещество", ЭлементДанных.activeSubstance);
	КонецЕсли;
	
	Если ЭлементДанных.Свойство("prepForm") Тогда
		ДанныеПАТ.Вставить("ПрепаративнаяФорма",  ЭлементДанных.prepForm);
	КонецЕсли;
	
	Если ЭлементДанных.Свойство("classDanger") Тогда
		ДанныеПАТ.Вставить("КлассОпасности",      ЭлементДанных.classDanger);
	КонецЕсли;

	Если ТипЗнч(ЭлементДанных.tukoManufacturerId) = Тип("Структура") Тогда
		
		ДанныеПАТ.Вставить("ДанныеПроизводителя", ЭлементДанных.tukoManufacturerId);
		
		Если ЭлементДанных.tukoManufacturerId.Свойство("id")
			И ЗначениеЗаполнено(ЭлементДанных.tukoManufacturerId.id) Тогда
			ДанныеПАТ.Вставить("ИдентификаторПроизводителя", ЭлементДанных.tukoManufacturerId.id);
		КонецЕсли;
		
	Иначе
		
		Если ТипЗнч(ЭлементДанных.tukoManufacturerId) = Тип("Число") И ЭлементДанных.tukoManufacturerId > 0
			Или (ЭлементДанных.Свойство("tukoManufacturerId__NAME") И ЗначениеЗаполнено(ЭлементДанных.tukoManufacturerId__NAME)) Тогда
			ДанныеПАТ.Вставить("ИдентификаторПроизводителя", ЭлементДанных.tukoManufacturerId);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭлементДанных.Свойство("_tparts") Тогда
		
		Если ЭлементДанных._tparts.Свойство("PAT_tbrec_tukoParts") Тогда
			
			Для Каждого ЭлементСоставаТукосмеси Из ЭлементДанных._tparts.PAT_tbrec_tukoParts Цикл
				
				СтруктураОписанияТукосмеси = Новый Структура();
				
				Если ТипЗнч(ЭлементСоставаТукосмеси.patProduct_id) = Тип("Структура") Тогда
				
					Если ЭлементСоставаТукосмеси.patProduct_id.Свойство("id") Тогда
					
						СтруктураОписанияТукосмеси.Вставить("ИдентификаторПА", ЭлементСоставаТукосмеси.patProduct_id.id);
						СтруктураОписанияТукосмеси.Вставить("ДанныеПА",        ЭлементСоставаТукосмеси.patProduct_id);
					
					ИначеЕсли ЭлементСоставаТукосмеси.patProduct_id.Свойство("_id") Тогда
						
						СтруктураОписанияТукосмеси.Вставить("ИдентификаторПА", ЭлементСоставаТукосмеси.patProduct_id._id);
						СтруктураОписанияТукосмеси.Вставить("ДанныеПА",        Неопределено);
					
					КонецЕсли;
					
				Иначе
					СтруктураОписанияТукосмеси.Вставить("ИдентификаторПА", ЭлементСоставаТукосмеси.patProduct_id);
					СтруктураОписанияТукосмеси.Вставить("ДанныеПА",        Неопределено);
				КонецЕсли;
				
				СтруктураОписанияТукосмеси.Вставить("Количество",          ЭлементСоставаТукосмеси.quantity);
				СтруктураОписанияТукосмеси.Вставить("ИдентификаторСтроки", ЭлементСоставаТукосмеси.id);
				
				ДанныеПАТ.СоставТукосмеси.Добавить(СтруктураОписанияТукосмеси);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;

	Возврат ДанныеПАТ;
	
КонецФункции

Процедура ОбработкаЗагрузкиПолученныхДанных(ЭлементОчереди, ПараметрыОбмена, ПолученныеДанные, ИзмененныеОбъекты) Экспорт
	
	РеквизитыИсходящегоСообщения = ЭлементОчереди.РеквизитыИсходящегоСообщения;
	
	Если ЭлементОчереди.Операция = Перечисления.ВидыОперацийСАТУРН.ПАТСозданиеКлассификатора Тогда
		
		СообщенияJSON = Новый Массив;
		
		Идентификатор = ПолученныеДанные.objList._OBJ_ARRAY[0].id;
		
		СправочникОбъект               = СоздатьЭлемент();
		СправочникОбъект.Идентификатор = Идентификатор;
		
		Попытка
			СправочникОбъект.Записать();
		Исключение
			ВызватьИсключение;
		КонецПопытки;
		
		ЭлементОчередиОснование               = ИнтеграцияСАТУРНСлужебный.ЭлементОчередиСообщенияОснования(ЭлементОчереди, ПараметрыОбмена);
		РеквизитыИсходящегоСообщенияОснования = ЭлементОчередиОснование.РеквизитыИсходящегоСообщения;
		РеквизитыИсходящегоСообщения          = ЭлементОчереди.РеквизитыИсходящегоСообщения;
		
		РеквизитыИсходящегоСообщенияОснования.ИдентификаторЗаявки = Идентификатор;
		
		СообщениеJSON = ИнтеграцияСАТУРНСлужебный.СтруктураСообщенияJSON();
		
		ИнтеграцияСАТУРНСлужебный.ЗаполнитьСообщениеПоИсточнику(СообщениеJSON, РеквизитыИсходящегоСообщения);
		
		СообщениеJSON.Документ            = СправочникОбъект.Ссылка;
		СообщениеJSON.Версия              = 1;
		СообщениеJSON.Операция            = Перечисления.ВидыОперацийСАТУРН.ПАТИзменениеКлассификатора;
		СообщениеJSON.Описание            = ИнтеграцияСАТУРНСлужебный.ОписаниеОперацииПередачиДанных(СообщениеJSON.Операция, СообщениеJSON.Документ);
		СообщениеJSON.ИдентификаторЗаявки = Идентификатор;
		СообщениеJSON.ПараметрыЗапроса    = РеквизитыИсходящегоСообщения.ПараметрыЗапроса;
		СообщениеJSON.АргументыОперации   = РеквизитыИсходящегоСообщенияОснования.АргументыОперации;
		СообщениеJSON.АргументыОперации.theCard._id = Идентификатор;
		
		СообщениеJSON.ПараметрыЗапроса.ДанныеОбъекта.Идентификатор = Идентификатор;
		
		СообщенияJSON.Добавить(СообщениеJSON);
		
		ИнтеграцияСАТУРНСлужебный.ПодготовитьКПередачеИсходныеСообщения(СообщенияJSON, ПараметрыОбмена);
		
	ИначеЕсли ЭлементОчереди.Операция = Перечисления.ВидыОперацийСАТУРН.ПАТИзменениеКлассификатора Тогда
		
		РеквизитыИсходящегоСообщения          = ЭлементОчереди.РеквизитыИсходящегоСообщения;
		ЭлементОчередиОснование               = ИнтеграцияСАТУРНСлужебный.ЭлементОчередиСообщенияОснования(ЭлементОчереди, ПараметрыОбмена);
		ПараметрыИсходящегоСообщенияОснования = РеквизитыИсходящегоСообщения.ПараметрыЗапроса;
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.КлассификаторПАТСАТУРН.ПолноеИмя());
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементОчереди.Документ);
		
		Попытка
			
			Блокировка.Заблокировать();
			
			СправочникОбъект               = ЭлементОчереди.Документ.ПолучитьОбъект();
			РеквизитыИсключения            = "";
			
			Если ЗначениеЗаполнено(СправочникОбъект.Статус) Тогда
				РеквизитыИсключения = "Статус";
			КонецЕсли;
				
			ЗаполнитьЗначенияСвойств(СправочникОбъект, ПараметрыИсходящегоСообщенияОснования.ДанныеОбъекта,, РеквизитыИсключения);
			
			СправочникОбъект.СоставТукосмеси.Очистить();
			
			Для Каждого СтрокаСоставаТукосмеси Из ПараметрыИсходящегоСообщенияОснования.ДанныеОбъекта.СоставТукосмеси Цикл
				
				Если СтрокаСоставаТукосмеси.Удалить Тогда
					Продолжить;
				КонецЕсли;
				
				НоваяСтрокаСостава = СправочникОбъект.СоставТукосмеси.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаСостава, СтрокаСоставаТукосмеси);
				
			КонецЦикла;
			
			СправочникОбъект.Записать();
			
		Исключение
			ВызватьИсключение;
		КонецПопытки;
	
	ИначеЕсли ЭлементОчереди.Операция = Перечисления.ВидыОперацийСАТУРН.ПАТСменаСтатусаИзЧерновикаВОтменено Тогда
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.КлассификаторПАТСАТУРН.ПолноеИмя());
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементОчереди.Документ);
		
		Попытка
			
			Блокировка.Заблокировать();
			
			СправочникОбъект        = ЭлементОчереди.Документ.ПолучитьОбъект();
			СправочникОбъект.Статус = Перечисления.СтатусыОбъектовСАТУРН.Отменен;
			СправочникОбъект.Записать();
			
		Исключение
			ВызватьИсключение;
		КонецПопытки;
		
	ИначеЕсли ЭлементОчереди.Операция = Перечисления.ВидыОперацийСАТУРН.ПАТСменаСтатусаИзЧерновикВАктуально Тогда
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.КлассификаторПАТСАТУРН.ПолноеИмя());
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементОчереди.Документ);
		
		Попытка
			
			Блокировка.Заблокировать();
			
			СправочникОбъект        = ЭлементОчереди.Документ.ПолучитьОбъект();
			СправочникОбъект.Статус = Перечисления.СтатусыОбъектовСАТУРН.Актуально;
			СправочникОбъект.Записать();
			
		Исключение
			ВызватьИсключение;
		КонецПопытки;
	
	ИначеЕсли ЭлементОчереди.Операция = ОперацияЗагрузкиКлассификатора() Тогда
		
		ВходящиеДанные = ИнтеграцияСАТУРНСлужебный.ОбработатьРезультатЗапросаСпискаОбъектов(ПолученныеДанные, ПараметрыОбмена);
		ИнтеграцияСАТУРНСлужебный.СсылкиПоИдентификаторам(ПараметрыОбмена, ИзмененныеОбъекты);
		
		Попытка
			
			Для Каждого ЭлементДанных Из ВходящиеДанные Цикл
				
				ДанныеОбъекта   = ДанныеОбъекта(ЭлементДанных);
				СсылкаНаЭлемент = ЗагрузитьОбъект(ДанныеОбъекта, ПараметрыОбмена,,, ЭлементОчереди.ОрганизацияСАТУРН);
				
				Если Не ЗначениеЗаполнено(СсылкаНаЭлемент) Тогда
					Продолжить;
				КонецЕсли;
				ИзмененныеОбъекты.Добавить(СсылкаНаЭлемент);
				
			КонецЦикла;
			
		Исключение
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОперацияЗагрузкиКлассификатора() Экспорт
	Возврат Перечисления.ВидыОперацийСАТУРН.ПАТЗапросКлассификатора;
КонецФункции

Функция СтруктураПередачиJSON()
	
	СтруктураДанных = Новый Структура;
	
	СтруктураДанных.Вставить("_id",                Неопределено);
	СтруктураДанных.Вставить("lcState",            "");
	СтруктураДанных.Вставить("name",               "");
	СтруктураДанных.Вставить("okpd",               "");
	СтруктураДанных.Вставить("type",               "");
	СтруктураДанных.Вставить("description",        "");
	СтруктураДанных.Вставить("tukoManufacturerId", "");
	СтруктураДанных.Вставить("_tparts",            Новый Структура);
	
	Возврат СтруктураДанных;
	
КонецФункции

#КонецОбласти

#Область ПоискСсылок

Функция ПАТ(Идентификатор, ПараметрыОбмена, ОрганизацияСАТУРН = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Идентификатор)
		Или Идентификатор = -1 Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	ИмяТаблицы       = Метаданные.Справочники.КлассификаторПАТСАТУРН.ПолноеИмя();
	СправочникСсылка = ИнтеграцияСАТУРНСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, Идентификатор);
	
	Если ЗначениеЗаполнено(СправочникСсылка) Тогда
		ИнтеграцияСАТУРНСлужебный.ОбновитьСсылку(ПараметрыОбмена, ИмяТаблицы, Идентификатор, СправочникСсылка);
	Иначе
		
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить(ИмяТаблицы);
		ЭлементБлокировки.УстановитьЗначение("Идентификатор", Идентификатор);
		
		ТранзакцияЗафиксирована = Истина;
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка.Заблокировать();
			
			СправочникСсылка = ИнтеграцияСАТУРНСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, Идентификатор);
			
			Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
				ДанныеОбъекта = ИнтеграцияСАТУРНСлужебный.ДанныеОбъекта(
					Идентификатор,
					Метаданные.Справочники.КлассификаторПАТСАТУРН, ПараметрыОбмена);
				Если ДанныеОбъекта = Неопределено Тогда
					СправочникСсылка = СоздатьПАТ(Идентификатор, ПараметрыОбмена);
					ИнтеграцияСАТУРНСлужебный.ДобавитьКЗагрузке(ПараметрыОбмена, ИмяТаблицы, Идентификатор, СправочникСсылка, ОрганизацияСАТУРН);
				Иначе
					СправочникСсылка = ЗагрузитьОбъект(ДанныеОбъекта, ПараметрыОбмена,, Ложь, ОрганизацияСАТУРН);
				КонецЕсли;
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТранзакцияЗафиксирована = Ложь;
			
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка при создании ПАТ с идентификатором %1:
				           |%2'"),
				Идентификатор,
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ТекстОшибкиПодробно = СтрШаблон(
				НСтр("ru = 'Ошибка при создании ПАТ с идентификатором %1:
				           |%2'"),
				Идентификатор,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ОбщегоНазначенияИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
				ТекстОшибкиПодробно,
				НСтр("ru = 'Работа с ПАТ'", ОбщегоНазначения.КодОсновногоЯзыка()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки;
		
		Если ТранзакцияЗафиксирована Тогда
			ИнтеграцияСАТУРНСлужебный.ОбновитьСсылку(ПараметрыОбмена, ИмяТаблицы, Идентификатор, СправочникСсылка);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СправочникСсылка;
	
КонецФункции

Функция ЗагрузитьОбъект(ДанныеПАТ, ПараметрыОбмена, СправочникОбъект = Неопределено, ТребуетсяПоиск = Истина, ОрганизацияСАТУРН = Неопределено) Экспорт
	
	ЗаписьНового       = Ложь;
	МетаданныеЭлемента = Метаданные.Справочники.КлассификаторПАТСАТУРН;
	
	Идентификатор = ДанныеПАТ.Идентификатор;
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	Если СправочникОбъект = Неопределено Тогда
		
		СуществующийЭлемент = Неопределено;
		Если ТребуетсяПоиск Тогда
			СуществующийЭлемент = ИнтеграцияСАТУРНСлужебный.СсылкаПоИдентификатору(
				ПараметрыОбмена,
				МетаданныеЭлемента.ПолноеИмя(),
				Идентификатор);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СуществующийЭлемент) Тогда
			
			СправочникОбъект = СоздатьЭлемент();
			СправочникОбъект.Заполнить(Неопределено);
			
			ИдентификаторОбъекта = Новый УникальныйИдентификатор();
			СправочникОбъект.УстановитьСсылкуНового(ПолучитьСсылку(ИдентификаторОбъекта));
			СправочникОбъект.Идентификатор = Идентификатор;
			
			ЗаписьНового = Истина;
			
		Иначе
			СправочникОбъект = СуществующийЭлемент.ПолучитьОбъект();
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗаписьНового Тогда
		СправочникОбъект.Заблокировать();
	КонецЕсли;
	
	СправочникОбъект.Статус                          = ДанныеПАТ.Статус;
	СправочникОбъект.ОКПД2                           = ДанныеПАТ.ОКПД2;
	СправочникОбъект.Наименование                    = ДанныеПАТ.Наименование;
	СправочникОбъект.ВидПродукции                    = ДанныеПАТ.ВидПродукции;
	СправочникОбъект.Группа                          = ДанныеПАТ.Группа;
	СправочникОбъект.Регистрант                      = ДанныеПАТ.Регистрант;
	СправочникОбъект.НомерГосударственнойРегистрации = ДанныеПАТ.НомерГосударственнойРегистрации;
	СправочникОбъект.ДатаРегистрации                 = ДанныеПАТ.ДатаРегистрации;
	СправочникОбъект.ДатаОкончанияРегистрации        = ДанныеПАТ.ДатаОкончанияРегистрации;
	СправочникОбъект.ДействующееВещество             = ДанныеПАТ.ДействующееВещество;
	СправочникОбъект.ПрепаративнаяФорма              = ДанныеПАТ.ПрепаративнаяФорма;
	СправочникОбъект.СодержаниеДействующегоВещества  = ДанныеПАТ.СодержаниеДействующегоВещества;
	СправочникОбъект.КлассОпасности                  = ДанныеПАТ.КлассОпасности;
	
	Если ЗначениеЗаполнено(ДанныеПАТ.ИдентификаторПроизводителя) Тогда

		СправочникОбъект.Производитель = Справочники.КлассификаторОрганизацийСАТУРН.Организация(
			ДанныеПАТ.ИдентификаторПроизводителя,
			ПараметрыОбмена,
			ОрганизацияСАТУРН);
		
	КонецЕсли;
	
	СправочникОбъект.СоставТукосмеси.Очистить();
	
	Если ДанныеПАТ.СоставТукосмеси.Количество() Тогда
		
		Для Каждого ЭлементСоставаТукосмеси Из ДанныеПАТ.СоставТукосмеси Цикл
			
			Если НЕ ЗначениеЗаполнено(ЭлементСоставаТукосмеси.ИдентификаторПА) Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрокаСоставаТукосмеси = СправочникОбъект.СоставТукосмеси.Добавить();
			
			НоваяСтрокаСоставаТукосмеси.ИдентификаторСтроки = ЭлементСоставаТукосмеси.ИдентификаторСтроки;
			НоваяСтрокаСоставаТукосмеси.ПА                  = ПАТ(ЭлементСоставаТукосмеси.ИдентификаторПА, ПараметрыОбмена, ОрганизацияСАТУРН);
			НоваяСтрокаСоставаТукосмеси.Количество          = ЭлементСоставаТукосмеси.Количество;
			
		КонецЦикла;
		
	КонецЕсли;

	СправочникОбъект.ТребуетсяЗагрузка = Ложь;
	СправочникОбъект.Записать();
	
	ИнтеграцияСАТУРНСлужебный.ОбновитьСсылку(
		ПараметрыОбмена,
		МетаданныеЭлемента.ПолноеИмя(),
		Идентификатор,
		СправочникОбъект.Ссылка);
	
	Возврат СправочникОбъект.Ссылка;
	
КонецФункции

Функция СоздатьПАТ(Идентификатор, ПараметрыОбмена)
	
	СправочникОбъект = СоздатьЭлемент();
	СправочникОбъект.Идентификатор     = Идентификатор;
	СправочникОбъект.ТребуетсяЗагрузка = Истина;
	СправочникОбъект.Наименование      = НСтр("ru = '<Требуется загрузка>'");
	
	СправочникОбъект.Записать();
	
	Возврат СправочникОбъект.Ссылка;
	
КонецФункции

#КонецОбласти

#Область Сообщения

// Сообщение к передаче JSON.
//
// Параметры:
//  СправочникСсылка - СправочникСсылка.КлассификаторПАТСАТУРН - Ссылка на ПАТ.
//  ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюСАТУРН - Дальнейшее действие.
//  ДополнительныеПараметры - Структура, Неопределено - Дополнительные параметры.
//
// Возвращаемое значение:
//  Массив Из См. ИнтеграцияСАТУРНСлужебный.СтруктураСообщенияJSON - Сообщения к передаче.
//
Функция СообщениеКПередачеJSON(СправочникСсылка, ДальнейшееДействие, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыОбработки = Неопределено;
	НовыйСтатус        = Неопределено;
	ДанныеОбъекта      = Неопределено;
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ПараметрыОбработкиДокумента")
		И ТипЗнч(ДополнительныеПараметры.ПараметрыОбработкиДокумента) = Тип("Структура")
		И ДополнительныеПараметры.ПараметрыОбработкиДокумента.Свойство("ДополнительныеПараметры") Тогда
		
		ПараметрыОбработки = ДополнительныеПараметры.ПараметрыОбработкиДокумента.ДополнительныеПараметры;
		
		Если ТипЗнч(ПараметрыОбработки) = Тип("Структура") Тогда
			
			Если ПараметрыОбработки.Свойство("НовыйСтатус") Тогда
			
				НовыйСтатус = ПараметрыОбработки.НовыйСтатус;
			
			КонецЕсли;
			
			Если ПараметрыОбработки.Свойство("ДанныеПАТ") Тогда
				
				ДанныеОбъекта = ПараметрыОбработки.ДанныеПАТ;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СообщенияJSON = Новый Массив;
	
	Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ПередайтеДанные Тогда
		
		Если ДанныеОбъекта <> Неопределено Тогда
			
			ДобавитьСообщенияJSON = СозданиеИзменениеКлассификатораПАТJSON(СправочникСсылка, ДанныеОбъекта);
			
			Если ДобавитьСообщенияJSON <> Неопределено Тогда
				
				Для Каждого СообщениеJSON Из ДобавитьСообщенияJSON Цикл
					СообщенияJSON.Добавить(СообщениеJSON);
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если НовыйСтатус <> Неопределено Тогда
			
			ДобавитьСообщенияJSON = СменаСтатусаКлассификатораПАТJSON(СправочникСсылка, НовыйСтатус);
			
			Если ДобавитьСообщенияJSON <> Неопределено Тогда
				
				Для Каждого СообщениеJSON Из ДобавитьСообщенияJSON Цикл
					СообщенияJSON.Добавить(СообщениеJSON);
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	Возврат СообщенияJSON;
	
КонецФункции

// Формирует JSON сообщения для создания/изменения ПАТ.
//
// Параметры:
//  СправочникСсылка - СправочникСсылка.КлассификаторПАТСАТУРН - Ссылка на ПАТ.
//  ДанныеОбъекта - Структура из См. ИнтеграцияСАТУРНКлиентСервер.СтруктураДанныхПАТ - описание справочника
//
// Возвращаемое значение:
//  Массив Из См. ИнтеграцияСАТУРНСлужебный.СтруктураСообщенияJSON - Сообщения к передаче
//
Функция СозданиеИзменениеКлассификатораПАТJSON(СправочникСсылка, ДанныеОбъекта)
	
	СообщенияJSON  = Новый Массив;

	СообщениеJSON = ИнтеграцияСАТУРНСлужебный.СтруктураСообщенияJSON();
	СообщениеJSON.Документ            = СправочникСсылка;
	СообщениеJSON.Версия              = 1;
	СообщениеJSON.Описание            = ИнтеграцияСАТУРНСлужебный.ОписаниеОперацииПередачиДанных(СообщениеJSON.Операция, СправочникСсылка);
	СообщениеJSON.АргументыОперации   = Новый Структура;
	СообщениеJSON.ПараметрыЗапроса    = Новый Структура;
	СообщениеJSON.ПараметрыЗапроса.Вставить("ДанныеОбъекта", ДанныеОбъекта);
	
	Если ЗначениеЗаполнено(СправочникСсылка) Тогда
		
		СообщениеJSON.Операция            = Перечисления.ВидыОперацийСАТУРН.ПАТИзменениеКлассификатора;
		РеквизитыПАТ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СправочникСсылка, "Идентификатор");
		
		СообщениеJSON.ИдентификаторЗаявки = РеквизитыПАТ.Идентификатор;
	
	Иначе
		СообщениеJSON.Операция          = Перечисления.ВидыОперацийСАТУРН.ПАТСозданиеКлассификатора;
	КонецЕсли;
	
	СообщенияJSON.Добавить(СообщениеJSON);
	
	АргументыОперации = СообщениеJSON.АргументыОперации;
	
	АргументыОперации.Вставить("theCard",       СтруктураПередачиJSON());
	
	ДанныеПАТ = АргументыОперации.theCard;
	
	ДанныеПАТ._id                    = СообщениеJSON.ИдентификаторЗаявки;
	ДанныеПАТ.lcState                = ИнтерфейсСАТУРН.Статус(ДанныеОбъекта.Статус);
	ДанныеПАТ.name                   = ДанныеОбъекта.Наименование;
	ДанныеПАТ.okpd                   = ДанныеОбъекта.ОКПД2;
	ДанныеПАТ.type                   = ИнтерфейсСАТУРН.ВидПродукции(ДанныеОбъекта.ВидПродукции);
	
	Если ЗначениеЗаполнено(ДанныеОбъекта.Производитель) Тогда
		ДанныеПАТ.tukoManufacturerId = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеОбъекта.Производитель, "Идентификатор");
	КонецЕсли;
	
	Если ДанныеОбъекта.СоставТукосмеси.Количество() Тогда
		
		МассивСтрокСостава = Новый Массив;
		
		Для Каждого ЭлементСоставаТукосмеси Из ДанныеОбъекта.СоставТукосмеси Цикл
			
			Если ЭлементСоставаТукосмеси.БезИзменений Тогда
				Продолжить;
			КонецЕсли;
			
			СтруктураОписанияЭлементаСостава = Новый Структура;
			СтруктураОписанияЭлементаСостава.Вставить("patProduct_id", ЭлементСоставаТукосмеси.ИдентификаторПА);
			СтруктураОписанияЭлементаСостава.Вставить("quantity",      ЭлементСоставаТукосмеси.Количество);
			СтруктураОписанияЭлементаСостава.Вставить("_id",           ЭлементСоставаТукосмеси.ИдентификаторСтроки);
			
			Если ЭлементСоставаТукосмеси.Удалить Тогда
				СтруктураОписанияЭлементаСостава.Вставить("_toDelete",     ЭлементСоставаТукосмеси.Удалить); 
			КонецЕсли;
			
			МассивСтрокСостава.Добавить(СтруктураОписанияЭлементаСостава);
			
		КонецЦикла;
		
		ДанныеПАТ._tparts.Вставить("PAT_tbrec_tukoParts", МассивСтрокСостава);
		
	КонецЕсли;
	
	Возврат СообщенияJSON;
	
КонецФункции

// Формирует JSON сообщения для смены статуса ПАТ.
//
// Параметры:
//  СправочникСсылка - СправочникСсылка.КлассификаторПАТСАТУРН - Ссылка на ПАТ.
//  НовыйСтатус - ПеречислениеСсылка.СтатусыОбъектовСАТУРН - статус к установке
//
// Возвращаемое значение:
//  Массив из Структура - см. ИнтеграцияСАТУРНСлужебный.СтруктураСообщенияJSON - Сообщения к передаче
//
Функция СменаСтатусаКлассификатораПАТJSON(СправочникСсылка, НовыйСтатус)
	
	Операция      = Неопределено;
	СообщенияJSON = Новый Массив;
	
	Если НовыйСтатус = Перечисления.СтатусыОбъектовСАТУРН.Актуально Тогда
		Операция = Перечисления.ВидыОперацийСАТУРН.ПАТСменаСтатусаИзЧерновикВАктуально;
	ИначеЕсли НовыйСтатус = Перечисления.СтатусыОбъектовСАТУРН.Отменен Тогда
		Операция = Перечисления.ВидыОперацийСАТУРН.ПАТСменаСтатусаИзЧерновикаВОтменено;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	СообщениеJSON = ИнтеграцияСАТУРНСлужебный.СтруктураСообщенияJSON();
	СообщениеJSON.Документ            = СправочникСсылка;
	СообщениеJSON.Версия              = 1;
	СообщениеJSON.Описание            = ИнтеграцияСАТУРНСлужебный.ОписаниеОперацииПередачиДанных(СообщениеJSON.Операция, СправочникСсылка);
	СообщениеJSON.АргументыОперации   = Новый Структура;
	СообщениеJSON.ИдентификаторЗаявки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СправочникСсылка, "Идентификатор");
	СообщениеJSON.Операция            = Операция;
	
	СообщенияJSON.Добавить(СообщениеJSON);
	
	Возврат СообщенияJSON;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли