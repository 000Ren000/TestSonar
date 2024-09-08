﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	GUIDРайона  = Параметры.GUIDРайона;
	GUIDРегиона = Параметры.GUIDРегиона;
	
	ЗагрузитьСписок(Неопределено, 1);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ТекущиеДанные = Элементы.НаселенныеПункты.ТекущиеДанные;
	
	Данные = Новый Структура;
	Данные.Вставить("Активность",    ТекущиеДанные.Активность);
	Данные.Вставить("Актуальность",  ТекущиеДанные.Актуальность);
	Данные.Вставить("GUID",          ТекущиеДанные.GUID);
	Данные.Вставить("UUID",          ТекущиеДанные.UUID);
	Данные.Вставить("Статус",        ТекущиеДанные.Статус);
	Данные.Вставить("Наименование",  ТекущиеДанные.Наименование);
	Данные.Вставить("НаименованиеПолное",  ТекущиеДанные.НаименованиеПолное);
	Данные.Вставить("ДатаСоздания",  ТекущиеДанные.ДатаСоздания);
	Данные.Вставить("ДатаИзменения", ТекущиеДанные.ДатаИзменения);
	
	Закрыть(Данные);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписок(ПараметрыПоиска, НомерСтраницы)
	
	Если ЗначениеЗаполнено(GUIDРайона) Тогда
		Результат = ИкарВЕТИСВызовСервера.СписокНаселенныхПунктовРайона(GUIDРайона, НомерСтраницы);
	Иначе
		Результат = ИкарВЕТИСВызовСервера.СписокНаселенныхПунктовРегиона(GUIDРегиона, НомерСтраницы);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	НаселенныеПункты.Очистить();
	Для Каждого СтрокаТЧ Из Результат.Список Цикл
		
		НоваяСтрока = НаселенныеПункты.Добавить();
		НоваяСтрока.Активность    = СтрокаТЧ.active;
		НоваяСтрока.Актуальность  = СтрокаТЧ.last;
		НоваяСтрока.GUID          = СтрокаТЧ.GUID;
		НоваяСтрока.UUID          = СтрокаТЧ.UUID;
		НоваяСтрока.Наименование  = СтрокаТЧ.Name;
		НоваяСтрока.ДатаСоздания  = СтрокаТЧ.createDate;
		НоваяСтрока.ДатаИзменения = СтрокаТЧ.updateDate;
		
		НоваяСтрока.Статус = ИнтеграцияВЕТИСПовтИсп.СтатусВерсионногоОбъекта(СтрокаТЧ.status);
		
		НоваяСтрока.Тип                = СтрокаТЧ.type;
		НоваяСтрока.НаименованиеПолное = СтрокаТЧ.view;
		
	КонецЦикла;
	
	НаселенныеПунктыОбщееКоличество = Результат.ОбщееКоличество;
	НаселенныеПунктыНомерСтраницы   = НомерСтраницы;
	НаселенныеПунктыПараметрыПоиска = ПараметрыПоиска;
	
	КоличествоСтраниц = НаселенныеПунктыОбщееКоличество / ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	Если Цел(КоличествоСтраниц) <> КоличествоСтраниц Тогда
		КоличествоСтраниц = Цел(КоличествоСтраниц) + 1;
	КонецЕсли;
	Если КоличествоСтраниц = 0 Тогда
		КоличествоСтраниц = 1;
	КонецЕсли;
	
	Команды["НавигацияСтраницаТекущаяСтраница"].Заголовок =
		СтрШаблон(
			НСтр("ru = 'Страница %1 из %2'"),
			НаселенныеПунктыНомерСтраницы, КоличествоСтраниц);
	
	Элементы.СтраницаСледующая.Доступность  = (НаселенныеПунктыНомерСтраницы < КоличествоСтраниц);
	Элементы.СтраницаПредыдущая.Доступность = (НаселенныеПунктыНомерСтраницы > 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПервая(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(НаселенныеПунктыПараметрыПоиска, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПоследняя(Команда)
	
	ОчиститьСообщения();
	
	КоличествоСтраниц = НаселенныеПунктыОбщееКоличество / ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	Если Цел(КоличествоСтраниц) <> КоличествоСтраниц Тогда
		КоличествоСтраниц = Цел(КоличествоСтраниц) + 1;
	КонецЕсли;
	Если КоличествоСтраниц = 0 Тогда
		КоличествоСтраниц = 1;
	КонецЕсли;
	
	ЗагрузитьСписок(НаселенныеПунктыПараметрыПоиска, КоличествоСтраниц);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПредыдущая(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(НаселенныеПунктыПараметрыПоиска, НаселенныеПунктыНомерСтраницы - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаСледующая(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(НаселенныеПунктыПараметрыПоиска, НаселенныеПунктыНомерСтраницы + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаТекущаяСтраница(Команда)
	
	ОчиститьСообщения();
	
КонецПроцедуры

&НаКлиенте
Процедура НаселенныеПунктыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Выбрать(Неопределено);
	
КонецПроцедуры
